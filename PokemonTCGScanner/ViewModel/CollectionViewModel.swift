//
//  CollectionViewModel.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import Foundation

struct CardData: Codable {
    let id: String
    let owned: Int
}

class CollectionViewModel: ObservableObject {
    
    static var shared = CollectionViewModel()
    
    @Published var cards: [Card] = [] {
        didSet {
            saveOwnedValues()
        }
    }
    
    private var ownedValues: [String: Int] = [:]
    private let fileName = "ownedValues.json"
    
    init() {
        loadOwnedValues()
        Task {
            try? await fetchAndMergeCards()
        }
    }
    
    init(cards: [Card]) {
        self.cards = cards
        saveOwnedValues()
    }
    
    func addCard(_ card: Card) {
        self.cards.append(card)
    }
    
    private func saveOwnedValues() {
        let cardDataList = cards.map { CardData(id: $0.id, owned: $0.owned ?? 1) }
        
        if let data = try? JSONEncoder().encode(cardDataList) {
            let url = getFileURL()
            do {
                try data.write(to: url)
            } catch {
                print("Failed to save owned values: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadOwnedValues() {
        let url = getFileURL()
        guard let data = try? Data(contentsOf: url) else { return }
        
        if let cardDataList = try? JSONDecoder().decode([CardData].self, from: data) {
            self.ownedValues = Dictionary(uniqueKeysWithValues: cardDataList.map { ($0.id, $0.owned) })
        }
    }
    
    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
    func getCardIDs() -> [String] {
        return Array(ownedValues.keys)
    }
    
    private func fetchAndMergeCards() async throws {
        let cardIds = getCardIDs()
        guard !cardIds.isEmpty else { return }
        
        do {
            let fetchedCards = try await fetchCards(cardIds: cardIds)
            updateCardsWithFetchedData(fetchedCards)
        } catch {
            print("Error fetching cards from API: \(error.localizedDescription)")
        }
    }
    
    private func fetchCards(cardIds: [String]) async throws -> [Card] {
        let concatenatedString = cardIds.joined(separator: " OR id:")
        let request = await URLRequest.withAuth(apiPath: "https://api.pokemontcg.io/v2/cards?q=id:\(concatenatedString)")
        
        do {
            let (responseBody, _) = try await URLSession.shared.json(for: request, responseFormat: CardBody.self)
            return responseBody.data
        } catch {
            throw error
        }
    }
    
    private func updateCardsWithFetchedData(_ fetchedCards: [Card]) {
        self.cards = fetchedCards.map { card in
            var updatedCard = card
            if let owned = ownedValues[card.id] {
                updatedCard.owned = owned
            }
            return updatedCard
        }
    }
}


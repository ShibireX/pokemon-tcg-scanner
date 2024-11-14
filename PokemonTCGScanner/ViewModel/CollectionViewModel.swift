//
//  CollectionViewModel.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import Foundation

class CollectionViewModel: ObservableObject {
    
    static var shared = CollectionViewModel()
    
    @Published var cards: [Card] = [] {
        didSet {
            saveCards()
        }
    }
    
    private let fileName = "cardCollection.json"
    
    init() {
        loadCards()
    }
    
    init(cards: [Card]) {
        self.cards = cards
        saveCards()
    }
    
    func addCard(_ card: Card) {
        self.cards.append(card)
    }
    
    private func saveCards() {
        let cardIds = self.cards.map { $0.id }
        
        if let data = try? JSONEncoder().encode(cardIds) {
            let url = getFileUrl()
            do {
                try data.write(to: url)
            } catch {
                print("Failed to save cards: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadCards() {
        let url = getFileUrl()
        guard let data = try? Data(contentsOf: url) else { return }
        
        if let cardIds = try? JSONDecoder().decode([String].self, from: data) {
            Task {
                try? await fetchCards(cardIds: cardIds)
            }
        }
    }
    
    private func getFileUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
    
    func fetchCards(cardIds: [String]) async throws {
        let concatenatedString = cardIds.joined(separator: " OR id:")
                
        let request = await URLRequest.withAuth(apiPath: "https://api.pokemontcg.io/v2/cards?q=id:\(concatenatedString)")
                
        do {
            let (responseBody, _) = try await URLSession.shared.json(for: request, responseFormat: CardBody.self)
            
            Task { @MainActor in
                self.cards = responseBody.data
            }
        } catch {
            print(error)
            throw(error)
        }
    }
    
}

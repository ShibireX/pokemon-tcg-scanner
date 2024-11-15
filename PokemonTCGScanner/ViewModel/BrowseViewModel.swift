//
//  BrowseViewModel.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import Foundation

class BrowseViewModel: ObservableObject {
    
    @Published var sets: [Set] = []
    @Published var cards: [Card] = []
    
    init() {
        Task {
            try? await fetchSets()
            try? await fetchCards()
        }
    }
    
    init(sets: [Set], cards: [Card]) {
        self.sets = sets
        self.cards = cards
    }
    
    func fetchSets() async throws {
        let request = await URLRequest.withAuth(apiPath: "https://api.pokemontcg.io/v2/sets?orderBy=-releaseDate")
                
        do {
            let (responseBody, _) = try await URLSession.shared.json(for: request, responseFormat: SetBody.self)
            
            Task { @MainActor in
                sets = responseBody.data
            }
        } catch {
            print(error)
            throw(error)
        }
    }
    
    func fetchSetCards(setId: String) async throws {
        let request = await URLRequest.withAuth(apiPath: "https://api.pokemontcg.io/v2/cards?q=set.id:\(setId)&orderBy=number")
                
        do {
            let cachedResponseBody = try? URLCache.shared.json(for: request, responseFormat: CardBody.self)
            if let cachedResponseBody = cachedResponseBody {
                Task { @MainActor in
                    if let index = self.sets.firstIndex(where: { $0.id == setId }) {
                        self.sets[index].cards = cachedResponseBody.data
                    }
                }
            }
            
            let (responseBody, _) = try await URLSession.shared.json(for: request, responseFormat: CardBody.self)
            Task { @MainActor in
                if let index = self.sets.firstIndex(where: { $0.id == setId }) {
                    self.sets[index].cards = responseBody.data
                }
            }
        } catch {
            print(error)
            throw(error)
        }
    }
    
    func fetchCards() async throws {
        let request = await URLRequest.withAuth(apiPath: "https://api.pokemontcg.io/v2/cards?pageSize=30")
                
        do {
            let (responseBody, _) = try await URLSession.shared.json(for: request, responseFormat: CardBody.self)
            
            Task { @MainActor in
                cards = responseBody.data
            }
        } catch {
            print(error)
            throw(error)
        }
    }
    
    func searchCards(name: String) async throws -> [Card] {
        let request = await URLRequest.withAuth(apiPath: "https://api.pokemontcg.io/v2/cards?q=name:\(name)*")
                
        do {
            let (responseBody, _) = try await URLSession.shared.json(for: request, responseFormat: CardBody.self)
            
            return responseBody.data
            
        } catch {
            print(error)
            throw(error)
        }
    }
    
}

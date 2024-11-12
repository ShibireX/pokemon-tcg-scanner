//
//  BrowseViewModel.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import Foundation

class BrowseViewModel: ObservableObject {
    
    @Published var sets: [Set] = []
    
    init() {
        Task {
            try? await fetchSets()
        }
    }
    
    init(sets: [Set]) {
        self.sets = sets
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
}

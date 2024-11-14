//
//  ScanViewModel.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import Foundation
import UIKit

class ScanViewModel: ObservableObject {
    
    var recognizedText: String = ""
    var matchingCards: [Card] = []
    @Published var identifiedCard: Card?
    @Published var isLoading: Bool = false
    
    func identifyCard(uiImage: UIImage) async {
        recognizedText = recognizeText(from: uiImage)
        let (cardNumber, totalSetPrints) = extractSetValues(text: recognizedText)
        try? await fetchMatchingCards(cardNumber: cardNumber, totalSetPrints: totalSetPrints)
    }
    
    func fetchMatchingCards(cardNumber: Int, totalSetPrints: Int) async throws {
        
        let request = await URLRequest.withAuth(apiPath: "https://api.pokemontcg.io/v2/cards?q=set.printedTotal:\(totalSetPrints)%20number:\(cardNumber)")
                
        do {
            let (responseBody, _) = try await URLSession.shared.json(for: request, responseFormat: CardBody.self)
            
            guard !responseBody.data.isEmpty else { 
                Task { @MainActor in
                    isLoading = false
                }
                return
            }
            
            Task { @MainActor in
                matchingCards = responseBody.data
                if matchingCards.count == 1 {
                    identifiedCard = matchingCards.first
                } else {
                    identifiedCard = matchingCards.first(where: { recognizedText.lowercased().contains($0.name.lowercased()) })
                }
                isLoading = false
            }
        } catch {
            Task { @MainActor in
                isLoading = false
            }
            print(error)
            throw(error)
        }
    }
    
}

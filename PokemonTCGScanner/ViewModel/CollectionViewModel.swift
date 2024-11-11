//
//  CollectionViewModel.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import Foundation

class CollectionViewModel: ObservableObject {
    
    static var shared = CollectionViewModel()
    
    @Published var cards: [Card] = []
    
    init() {
        
    }
    
    init(cards: [Card]) {
        self.cards = cards
    }
    
    func addCard(_ card: Card) {
        self.cards.append(card)
    }
    
}

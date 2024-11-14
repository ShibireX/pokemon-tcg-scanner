//
//  PreviewMocks.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import Foundation

struct PreviewMocks {
    
    static let browseViewMock: BrowseViewModel = {
        let encodedSets = try! Data(contentsOf: Bundle.main.url(forResource: "sets", withExtension: "json")!)
        let encodedSetCards = try! Data(contentsOf: Bundle.main.url(forResource: "setCards", withExtension: "json")!)
        
        let decoder = JSONDecoder()
        var decodedSets = try! decoder.decode(SetBody.self, from: encodedSets)
        let decodedSetCards = try! decoder.decode(CardBody.self, from: encodedSetCards)
        
        decodedSets.data[0].cards = decodedSetCards.data
        
        return BrowseViewModel(sets: decodedSets.data, cards: decodedSetCards.data)
        
    }()
    
    static let collectionViewMock: CollectionViewModel = {
        let encodedSetCards = try! Data(contentsOf: Bundle.main.url(forResource: "setCards", withExtension: "json")!)
        
        let decoder = JSONDecoder()
        let decodedSetCards = try! decoder.decode(CardBody.self, from: encodedSetCards)

        return CollectionViewModel(cards: decodedSetCards.data)
        
    }()
    
    
}

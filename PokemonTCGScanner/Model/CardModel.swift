//
//  CardModel.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import Foundation

struct CardBody: Decodable {
    let data: [Card]
}

struct Card: Decodable, Equatable, Hashable {
    
    let id: String
    let name: String
    let images: SetImages
    let cardmarket: CardMarket?
    let tcgplayer: TcgPlayer?
    
    struct SetImages: Codable, Equatable, Hashable {
        let small: URL
        let large: URL
    }
    
    struct CardMarket: Codable, Equatable, Hashable {
        let url: URL?
        let prices: CardPrices
        
        struct CardPrices: Codable, Equatable, Hashable {
            let lowPrice: Float
            let averageSellPrice: Float
            let trendPrice: Float
        }
    }
    
    struct TcgPlayer: Codable, Equatable, Hashable {
        let url: URL?
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case images
        case cardmarket
        case tcgplayer
    }
    
    init(id: String, name: String, images: SetImages, cardmarket: CardMarket?, tcgplayer: TcgPlayer?) {
        self.id = id
        self.name = name
        self.images = images
        self.cardmarket = cardmarket
        self.tcgplayer = tcgplayer
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        images = try container.decode(SetImages.self, forKey: .images)
        cardmarket = try container.decodeIfPresent(CardMarket.self, forKey: .cardmarket)
        tcgplayer = try container.decodeIfPresent(TcgPlayer.self, forKey: .tcgplayer)

    }
    
}

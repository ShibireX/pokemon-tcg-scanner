//
//  Set.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import Foundation

struct SetBody: Decodable {
    var data: [Set]
}

struct Set: Decodable, Equatable, Hashable {
    
    let id: String
    let name: String
    let images: SetImages
    
    var cards: [Card]?
    
    struct SetImages: Codable, Equatable, Hashable {
        let symbol: URL
        let logo: URL
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case images
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        images = try container.decode(SetImages.self, forKey: .images)
    }
    
}

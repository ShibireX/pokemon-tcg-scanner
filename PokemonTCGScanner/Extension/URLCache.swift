//
//  URLCache.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-15.
//

import Foundation

extension URLCache {
    
    enum CacheError: Error {
    case noCachedData
    }
    
    func json(for request: URLRequest) throws -> Any
    {
        let cachedResponse = URLCache.shared.cachedResponse(for: request)
        guard let data = cachedResponse?.data else {
            throw CacheError.noCachedData
        }
        
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        
        return jsonObject
    }
    
    func json<T: Decodable>(for request: URLRequest, responseFormat: T.Type) throws -> T
    {
        let cachedResponse = URLCache.shared.cachedResponse(for: request)
        guard let data = cachedResponse?.data else {
            throw CacheError.noCachedData
        }
        
        let decoder = JSONDecoder()
        let jsonObject = try decoder.decode(T.self, from: data)
        
        return jsonObject
    }
    
}

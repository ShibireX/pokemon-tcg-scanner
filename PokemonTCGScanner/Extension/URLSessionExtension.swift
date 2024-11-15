//
//  URLSessionExtension.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import Foundation

extension URLSession {
    
    enum JSONError: Error {
        case failedToDecode(data: Data, response: URLResponse)
    }
    
    func json(for request: URLRequest) async throws -> (Any, URLResponse)
    {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
                        
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data)
                URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                return (jsonObject, response)
            } catch {
                throw JSONError.failedToDecode(data: data, response: response)
            }
        } catch {
            throw error
        }
    }
    
    func json<T: Decodable>(for request: URLRequest, responseFormat: T.Type, printDebugInfo: Bool = false) async throws -> (T, URLResponse)
    {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if printDebugInfo {
                if let string = String(data: data, encoding: .utf8) {
                    print(string)
                } else {
                    print(data)
                }
            }
            
            let decoder = JSONDecoder()
            do {
                let jsonObject = try decoder.decode(T.self, from: data)
                URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                return (jsonObject, response)
            } catch {
                throw JSONError.failedToDecode(data: data, response: response)
            }
        } catch {
            throw error
        }
    }
    
}

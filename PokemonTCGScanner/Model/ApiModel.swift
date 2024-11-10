//
//  API.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import Foundation

extension URLRequest {
    
    enum HTTPMethod: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case connect = "CONNECT"
        case options = "OPTIONS"
        case trace = "TRACE"
        case patch = "PATCH"
    }
    
    mutating func setMethod(_ method: HTTPMethod) {
        httpMethod = method.rawValue
    }
    
    mutating func addAuthHeader() async throws {
        addValue(KeyConstants.APIKeys.APIKey, forHTTPHeaderField: "X-Api-Key")
    }
    
    static func withAuth(method: HTTPMethod = .get, apiPath: String) async -> URLRequest {
        var request = URLRequest(method: method, apiPath: apiPath)
        
        try? await request.addAuthHeader()
        
        return request
    }
    
    init(method: HTTPMethod = .get, apiPath: String) {
        let url = URL(string: apiPath)!
        self.init(url: url)
        
        setMethod(method)
    }
    
    var jsonHTTPBody: [String: Any]? {
        set {
            guard let newValue else {
                httpBody = nil
                return
            }
            
            setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            httpBody = try? JSONSerialization.data(withJSONObject: newValue, options: [])
        }
        get {
            fatalError("get jsonHTTPBody has not been implemented")
        }
    }
    
}

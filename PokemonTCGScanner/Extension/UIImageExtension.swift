//
//  UIImageExtension.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-11.
//

import UIKit

extension UIImage {
    
    static func cachedImage(forURL url: URL) -> UIImage? {
        let cacheRequest = URLRequest(url: url, cachePolicy: .returnCacheDataDontLoad)
        let cachedResponse = URLCache.shared.cachedResponse(for: cacheRequest)
        if let data = cachedResponse?.data {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    static func load(fromURL url: URL) async throws -> UIImage {
            return try await ImageLoader.shared.load(fromURL: url)
        }
    
    fileprivate actor ImageLoader {
        enum ImageError: Error {
            case invalidImageData
        }
        
        private var ongoingTasks: [URL: Task<UIImage, Error>] = [:]
        
        static let shared = ImageLoader()
        
        func load(fromURL url: URL) async throws -> UIImage {
            if let existingTask = ongoingTasks[url] {
                return try await existingTask.value
            } else {
                let task = Task { () throws -> UIImage in
                    let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
                    let (data, _) = try await URLSession.shared.data(for: urlRequest)
                    
                    guard let image = UIImage(data: data) else {
                        throw ImageError.invalidImageData
                    }
                    
                    return image
                }
                
                ongoingTasks[url] = task
                
                do {
                    let image = try await task.value
                    ongoingTasks.removeValue(forKey: url)
                    return image
                } catch {
                    ongoingTasks.removeValue(forKey: url)
                    throw error
                }
            }
        }
    }
    
}

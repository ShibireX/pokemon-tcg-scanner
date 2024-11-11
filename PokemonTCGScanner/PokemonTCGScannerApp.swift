//
//  PokemonTCGScannerApp.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import SwiftUI

@main
struct PokemonTCGScannerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .task {
                    do {
                        try await KeyConstants.loadAPIKeys()
                        setupURLCache()
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                }
        }
    }
    
    func setupURLCache() {
        let megabyte = 1024 * 1024
        
        let fileManager = FileManager.default
        let customCacheDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("http-cache")
        try! fileManager.createDirectory(at: customCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        
        URLCache.shared = URLCache(
            memoryCapacity: 100 * megabyte,
            diskCapacity: 100 * megabyte,
            diskPath: customCacheDirectory.path
        )
    }
    
}

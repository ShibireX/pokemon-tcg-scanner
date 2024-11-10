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
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                }
        }
    }
}

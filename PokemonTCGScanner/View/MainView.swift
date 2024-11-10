//
//  ContentView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            ScanView()
                .tabItem {
                    Image(systemName: "camera.aperture")
                    Text("Scan")
                }
            BrowseView(model: PreviewMocks.browseViewMock)
                .tabItem {
                    Image(systemName: "square.stack.3d.down.right")
                    Text("Browse")
                }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color(hexString: "#1f1f1f"))
        }
        .tint(.white)
    }
}

#Preview {
    MainView()
}

//
//  ContentView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import SwiftUI

struct MainView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            ScanView()
                .overlay(GlassyOverlay())
                .tabItem {
                    VStack {
                        Spacer().frame(height: 30)
                        Image(systemName: "camera.aperture")
                        Text("Scan")
                    }
                }
            BrowseView()
                .overlay(GlassyOverlay())
                .tabItem {
                    Image(systemName: "text.magnifyingglass.rtl")
                    Text("Browse")
                }
            CollectionView()
                .overlay(GlassyOverlay())
                .tabItem {
                    Image(systemName: "square.stack.3d.down.right")
                    Text("Collection")
                }
        }
        .tint(.white)
    }
    
    struct GlassyOverlay: View {
        var body: some View {
            VStack {
                Spacer()
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(height: 95)
            }
            .ignoresSafeArea()
        }
    }
    
}

#Preview {
    MainView()
}

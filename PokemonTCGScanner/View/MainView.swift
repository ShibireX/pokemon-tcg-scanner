//
//  ContentView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var browseViewModel: BrowseViewModel = BrowseViewModel()
    
    enum Tab {
        case scan
        case browse
        case collection
    }
    
    @State private var currentTab: Tab = .browse
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        if !browseViewModel.sets.isEmpty && !browseViewModel.cards.isEmpty {
            TabView(selection: $currentTab) {
                ScanView()
                    .overlay(GlassyOverlay().preferredColorScheme(.dark))
                    .tabItem {
                        VStack {
                            Spacer().frame(height: 30)
                            Image(systemName: "camera.aperture")
                            Text("Scan")
                        }
                    }
                    .tag(Tab.scan)
                BrowseView(model: browseViewModel)
                    .overlay(GlassyOverlay().preferredColorScheme(.dark))
                    .tabItem {
                        Image(systemName: "text.magnifyingglass.rtl")
                        Text("Browse")
                    }
                    .tag(Tab.browse)
                CollectionView()
                    .overlay(GlassyOverlay().preferredColorScheme(.dark))
                    .tabItem {
                        Image(systemName: "square.stack.3d.down.right")
                        Text("Collection")
                    }
                    .tag(Tab.collection)
            }
            .tint(.white)
            
        } else {
            LoadingScreenView()
        }
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

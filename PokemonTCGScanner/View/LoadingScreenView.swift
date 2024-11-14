//
//  LoadingScreen.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-14.
//

import SwiftUI

struct LoadingScreenView: View {
    
    @State var opacity: CGFloat = 0
    
    var body: some View {
        ZStack {
            Image("appLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .opacity(opacity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainColor)
        .onAppear {
            withAnimation {
                opacity = 1
            }
        }
    }
}

#Preview {
    LoadingScreenView()
}

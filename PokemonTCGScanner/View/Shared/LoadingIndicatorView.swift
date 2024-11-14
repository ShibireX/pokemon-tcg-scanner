//
//  LoadingIndicatorView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-14.
//

import SwiftUI

struct LoadingIndicatorView: View {
    
    var controlSize: Size = .normal
    
    enum Size {
        case small
        case normal
    }
    
    @State var scale: CGFloat = 1
    @State var rotation: CGFloat = 0
    
    var body: some View {
        Circle()
            .frame(width: 80)
            .foregroundStyle(.white.opacity(0.8).blendMode(.overlay))
            .overlay(
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: 27.5, height: 5)
                    Circle()
                        .frame(width: 25)
                    Rectangle()
                        .frame(width: 27.5, height: 5)
                }
                .foregroundStyle(.white.opacity(0.8).blendMode(.overlay))
            )
            .onAppear {
                withAnimation(.spring(duration: 1.4).repeatForever(autoreverses: true)) {
                    scale = 0.8
                }
                withAnimation(.spring(duration: 1.2).repeatForever(autoreverses: false)) {
                    rotation += 360
                }
            }
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .scaleEffect(controlSize == .normal ? 1 : 0.5)
    }
}

#Preview {
    ZStack {
        LoadingIndicatorView(controlSize: .small)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.mainColor)
}

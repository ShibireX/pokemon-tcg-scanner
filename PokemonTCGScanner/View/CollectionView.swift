//
//  CollectionView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import SwiftUI

struct CollectionView: View {
    
    @ObservedObject var model = CollectionViewModel.shared
    
    let gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                if !model.cards.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: gridColumns, spacing: 0) {
                            ForEach(model.cards, id: \.id) { card in
                                CardView(card: card)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                } else {
                    Text("No cards to show here yet")
                        .font(.system(size: 18))
                }
                
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hexString: "#1f1f1f"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Collection")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(.white)
                }
            }
        }
        .tint(.white)
    }
    
    struct CardView: View {
        
        let card: Card
        
        var body: some View {
            NavigationLink {
                CardDetailView(card: card)
            } label: {
                RemoteImageView(card.images.small)
                .aspectRatio(contentMode: .fit)
                .frame(height: 167)
            }
        }
    }
    
}

#Preview {
    CollectionView(model: PreviewMocks.collectionViewMock)
}

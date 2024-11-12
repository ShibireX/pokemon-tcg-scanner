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
                        LazyVStack(alignment: .leading) {
                            
                            HStack(spacing: 5) {
                                Text("My cards")
                                    .font(.system(size: 26, weight: .medium))
                                Spacer()
                                HStack {
                                    HStack(spacing: 5) {
                                        Image(systemName: "menucard.fill")
                                        Text(String(model.cards.count))
                                    }
                                    HStack(spacing: 2) {
                                        Image(systemName: "dollarsign")
                                        Text(sumCardValues())
                                    }
                                }
                                .font(.system(size: 16, weight: .semibold))
                            }
                            
                            LazyVGrid(columns: gridColumns, spacing: 0) {
                                ForEach(model.cards, id: \.id) { card in
                                    CardView(card: card)
                                }
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
    
    func sumCardValues() -> String {
        var value: Float = 0
        
        for card in model.cards {
            value += card.cardmarket?.prices.trendPrice ?? 0
        }
        
        return String(format: "%.2f", value)
    }
    
}

#Preview {
    CollectionView(model: PreviewMocks.collectionViewMock)
}

//
//  CardDetailView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import SwiftUI

struct CardDetailView: View {
    let card: Card
    
    @State var off: CGFloat = -400
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 35) {
                RemoteImageView(card.images.large)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 280)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.clear,
                                        Color.clear,
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.8),
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.2),
                                        Color.clear,
                                        Color.clear
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 1000)
                            .rotationEffect(.degrees(-35))
                            .contrast(1.2)
                            .blendMode(.overlay)
                            .offset(x: off)
                            .mask {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 280)
                            }
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring(duration: 3.2).repeatForever(autoreverses: false)) {
                                off = 400
                            }
                        }
                    }
                
                Text(card.name)
                    .font(.system(size: 28, weight: .black))
            }

            
            if let cardMarket = card.cardmarket {
                VStack(spacing: 25) {
                    HStack {
                        Spacer()
                        VStack(spacing: 3) {
                            Text("Low")
                            Group {
                                if cardMarket.prices.lowPrice > 0 {
                                    Text("$" + String(cardMarket.prices.lowPrice))
                                } else {
                                    Text("N/A")
                                }
                            }
                            .fontWeight(.black)
                        }
                        Spacer()
                        VStack(spacing: 3) {
                            Text("Average")
                            Group {
                                if cardMarket.prices.averageSellPrice > 0 {
                                    Text("$" + String(cardMarket.prices.averageSellPrice))
                                } else {
                                    Text("N/A")
                                }
                            }
                            .fontWeight(.black)
                        }
                        Spacer()
                        VStack(spacing: 3) {
                            Text("Current")
                            Group {
                                if cardMarket.prices.trendPrice > 0 {
                                    Text("$" + String(cardMarket.prices.trendPrice))
                                } else {
                                    Text("N/A")
                                }
                            }
                            .fontWeight(.black)
                        }
                        Spacer()
                    }
                    .font(.system(size: 22, weight: .medium))
                }
            }
            
            Spacer()
            
            AddToCollectionView(card: card)
            
            Spacer()
        }
        .padding()
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.mainColor)
    }
    
    struct AddToCollectionView: View {
        let card: Card
        
        @StateObject var model = CollectionViewModel.shared
        
        var body: some View {
            VStack(spacing: 15) {
                Text("Owned")
                    .font(.system(size: 18, weight: .semibold))
                
                HStack(spacing: 0) {
                    
                    Button {
                        if let index = model.cards.firstIndex(where: { $0.id == card.id }) {
                            model.cards.remove(at: index)
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 18)
                            .foregroundStyle(.black.opacity(0.4).blendMode(.overlay))
                            .frame(width: 45, height: 42)
                            .overlay(Image(systemName: "minus"))
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Text(model.cards.contains(card) ? "1" : "0")
                        .font(.system(size: 18, weight: .medium))
                        .monospacedDigit()
                        .frame(width: 40)
                    
                    Button {
                        if !model.cards.contains(card) {
                            model.addCard(card)
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 18)
                            .foregroundStyle(.black.opacity(0.4).blendMode(.overlay))
                            .frame(width: 45, height: 42)
                            .overlay(Image(systemName: "plus"))
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                }
                
            }
        }
    }
    
}

#Preview {
    CardDetailView(card: Card(id: "0", name: "Venusaur EX", images: Card.SetImages(small: URL(string: "https://images.pokemontcg.io/xy1/1.png")!, large: URL(string: "https://images.pokemontcg.io/xy1/1_hires.png")!), cardmarket: Card.CardMarket(url: URL(string: "example.com"), prices: Card.CardMarket.CardPrices(lowPrice: 2.42, averageSellPrice: 10.24, trendPrice: 20.41))))
}

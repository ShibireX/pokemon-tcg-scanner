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
                        .onAppear {
                            withAnimation(.spring(duration: 3.2).repeatForever(autoreverses: false)) {
                                off = 400
                            }
                        }
                        .mask {
                            RoundedRectangle(cornerRadius: 22)
                                .frame(height: 280)
                        }
                )
                
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
                    
                    if let url = cardMarket.url {
                        Button {
                            UIApplication.shared.open(url)
                        } label: {
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(height: 52)
                                .overlay(
                                    HStack {
                                        Text("See on TCGPlayer")
                                            .font(.system(size: 18, weight: .semibold))
                                        Image(systemName: "globe")
                                    }
                                )
                        }
                        .padding(.horizontal, 70)
                        .padding(.top, 30)
                    }
                }
            }
            
            Button {
                if !CollectionViewModel.shared.cards.contains(card) {
                    CollectionViewModel.shared.addCard(card)
                }
            } label: {
                RoundedRectangle(cornerRadius: 18)
                    .foregroundStyle(.ultraThinMaterial)
                    .frame(height: 52)
                    .overlay(
                        HStack {
                            Text("Add to Collection")
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "plus")
                        }
                    )
            }
            .padding(.horizontal, 70)
            .offset(y: -10)
            
            Spacer()
        }
        .padding()
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hexString: "#1f1f1f"))
    }
}

#Preview {
    CardDetailView(card: Card(id: "0", name: "Venusaur EX", images: Card.SetImages(small: URL(string: "https://images.pokemontcg.io/xy1/1.png")!, large: URL(string: "https://images.pokemontcg.io/xy1/1_hires.png")!), cardmarket: Card.CardMarket(url: URL(string: "example.com"), prices: Card.CardMarket.CardPrices(lowPrice: 2.42, averageSellPrice: 10.24, trendPrice: 20.41))))
}

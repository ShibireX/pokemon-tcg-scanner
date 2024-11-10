//
//  CardDetailView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import SwiftUI

struct CardDetailView: View {
    let card: Card
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                AsyncImage(url: card.images.large) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 280)
                
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
                            RoundedRectangle(cornerRadius: 22)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(height: 72)
                                .padding(.horizontal, 40)
                                .overlay(
                                    HStack {
                                        Text("See on TCGPlayer")
                                            .font(.system(size: 18, weight: .semibold))
                                        Image(systemName: "globe")
                                    }
                                )
                        }
                    }
                }
            }
            
            Button {
                // add to collection
            } label: {
                RoundedRectangle(cornerRadius: 22)
                    .foregroundStyle(.ultraThinMaterial)
                    .frame(height: 72)
                    .padding(.horizontal, 50)
                    .overlay(
                        HStack {
                            Text("Add to Collection")
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "plus")
                        }
                    )
            }
            .padding(.top, 30)
            
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

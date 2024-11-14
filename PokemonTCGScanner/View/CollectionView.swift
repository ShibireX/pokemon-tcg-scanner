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
    
    enum SortMethod {
        case type
    }
    
    @State var currentSortMethod: SortMethod = .type
    
    var sortedCards: [Card] {
        if currentSortMethod == .type {
            return model.cards.sorted(by: { $0.types?.first != $1.types?.first } )
        } else {
            return model.cards
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !model.cards.isEmpty {
                    ScrollView {
                        LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                            
                            Section(header: CollectionTypeHeader(model: model)) {
                                LazyVGrid(columns: gridColumns, spacing: 0) {
                                    ForEach(sortedCards, id: \.id) { card in
                                        SetCardsView.CardView(card: card)
                                    }
                                }
                            }
                            
                            // TODO: Wishlist
                            
                        }
                        .padding(.bottom, 120)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.top, 50)
                } else {
                    Text("No cards to show here yet")
                        .font(.system(size: 18))
                }
                
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mainColor)
            .ignoresSafeArea()
        }
        .tint(.white)
    }
    
    struct CollectionTypeHeader: View {
        
        @ObservedObject var model: CollectionViewModel
        
        var body: some View {
            HStack(spacing: 5) {
                Text("My cards")
                    .font(.system(size: 26, weight: .medium))
                Spacer()
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "menucard.fill")
                        Text(sumCardCounts())
                    }
                    HStack(spacing: 2) {
                        Image(systemName: "dollarsign")
                        Text(sumCardValues())
                    }
                }
                .font(.system(size: 16, weight: .semibold))
            }
            .padding(.bottom, 10)
            .background(Color.mainColor)
        }
        
        func sumCardValues() -> String {
            var value: Float = 0
            
            for card in model.cards {
                value += (card.cardmarket?.prices.trendPrice ?? 0) * Float(card.owned ?? 0)
            }
            
            return String(format: "%.2f", value)
        }
        
        func sumCardCounts() -> String {
            var count: Int = 0
            
            for card in model.cards {
                count += card.owned ?? 0
            }
            
            return String(count)
        }

        
    }
    
}

#Preview {
    CollectionView(model: PreviewMocks.collectionViewMock)
}

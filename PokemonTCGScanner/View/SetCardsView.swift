//
//  SetCardsView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import SwiftUI

struct SetCardsView: View {
    
    @ObservedObject var model: BrowseViewModel
    let setId: String
    let setName: String
    
    let gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            if let cards = model.sets.first(where: { $0.id == setId })?.cards {
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 0) {
                        ForEach(cards, id: \.id) { card in
                            CardView(card: card)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            } else {
                ProgressView()
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hexString: "#1f1f1f"))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(setName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
        .task {
            if model.sets.first(where: { $0.id == setId })?.cards == nil {
                try? await model.fetchSetCards(setId: setId)
            }
        }
    }
    
    struct CardView: View {
        
        let card: Card
        
        var body: some View {
            NavigationLink {
                CardDetailView(card: card)
            } label: {
                AsyncImage(url: card.images.small) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 167)
            }
        }
    }
    
}


#Preview {
    SetCardsView(model: PreviewMocks.browseViewMock, setId: "sv8", setName: "Surging Sparks")
}

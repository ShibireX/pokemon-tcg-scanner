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
        .background(Color.mainColor)
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
        .ignoresSafeArea(edges: .bottom)
    }
    
    struct CardView: View {
        
        let card: Card
        
        @State var opacity: CGFloat = 0
        @State var offset: CGFloat = -10
        
        var body: some View {
            NavigationLink {
                CardDetailView(card: card)
            } label: {
                RemoteImageView(card.images.small)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 167)
            }
            .opacity(opacity)
            .offset(y: offset)
            .onAppear {
                withAnimation {
                    opacity = 1
                    offset = 0
                }
            }
            .onDisappear {
                withAnimation {
                    opacity = 0
                    offset = -10
                }
            }
        }
    }
    
}


#Preview {
    SetCardsView(model: PreviewMocks.browseViewMock, setId: "sv8", setName: "Surging Sparks")
}

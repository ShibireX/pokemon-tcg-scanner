//
//  BrowseView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import SwiftUI

struct BrowseView: View {
    
    @ObservedObject var model = BrowseViewModel()
    
    let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 12) {
                        ForEach(model.sets, id: \.id) { set in
                            SetView(model: model, id: set.id, name: set.name, imageUrl: set.images.logo)
                        }
                    }
                    .padding(.top, 5)
                }
                .scrollIndicators(.hidden)
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hexString: "#1f1f1f"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Browse cards")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(.white)
                }
            }
        }
        .tint(.white)
    }
    
    struct SetView: View {
        
        @ObservedObject var model: BrowseViewModel
        
        let id: String
        let name: String
        let imageUrl: URL
        
        @State var setOpacity: CGFloat = 0
        @State var setOffset: CGFloat = -10
        
        var body: some View {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.clear)
                .frame(height: 120)
                .padding(.horizontal, 3)
                .overlay(
                    NavigationLink {
                        SetCardsView(model: model, setId: id, setName: name)
                    } label: {
                        RemoteImageView(imageUrl)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                            .onAppear {
                                withAnimation {
                                    setOpacity = 1
                                    setOffset = 0
                                }
                            }
                            .onDisappear {
                                withAnimation {
                                    setOpacity = 0
                                    setOffset = -10
                                }
                            }
                            .opacity(setOpacity)
                            .offset(y: setOffset)
                    }
                )
        }
    }
    
}

#Preview {
    BrowseView(model: PreviewMocks.browseViewMock)
}

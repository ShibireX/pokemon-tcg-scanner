//
//  BrowseView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-09.
//

import SwiftUI

struct BrowseView: View {
    
    @ObservedObject var model = BrowseViewModel()
    
    let setGridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    let cardGridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    enum Tab {
        case sets
        case cards
    }
    
    @State var currentTab: Tab = .sets
    
    @State var searchText: String = ""
    @State var isSearching: Bool = false
    @State var searchSets: [Set] = []
    @State var searchCards: [Card] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                BrowseTabBar(currentTab: $currentTab)
                
                SearchBar(searchText: $searchText, isSearching: $isSearching, currentTab: $currentTab) {
                    if !searchText.isEmpty {
                        if currentTab == .sets {
                            searchSets = model.sets.filter({ $0.name.contains(searchText) })
                        } else {
                            Task {
                                searchCards = try await model.searchCards(name: searchText)
                            }
                        }
                    } else {
                        searchSets = model.sets
                        searchCards = model.cards
                    }
                }
                .onAppear {
                    if searchText.isEmpty {
                        searchSets = model.sets
                        searchCards = model.cards
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: currentTab == .sets ? setGridColumns : cardGridColumns, spacing: currentTab == .sets ? 12 : 0) {
                        if currentTab == .sets {
                            ForEach(isSearching ? searchSets : model.sets, id: \.id) { set in
                                SetView(model: model, id: set.id, name: set.name, imageUrl: set.images.logo)
                            }
                        } else {
                            ForEach(isSearching ? searchCards : model.cards, id: \.id) { card in
                                SetCardsView.CardView(card: card)
                            }
                        }
                    }
                    .padding(.top, currentTab == .sets ? 0 : 15)
                    .padding(.bottom, 120)

                }
                .scrollIndicators(.hidden)
                
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mainColor)
            .ignoresSafeArea(edges: .bottom)
        }
        .tint(.white)
        .onChange(of: currentTab) {
            searchText = ""
            searchSets = model.sets
            searchCards = model.cards
        }
    }
    
    struct BrowseTabBar: View {
        
        @Binding var currentTab: Tab
        
        var body: some View {
            HStack(spacing: 50) {
                Button {
                    currentTab = .sets
                } label: {
                    VStack(spacing: 7) {
                        Text("Sets")
                        Rectangle()
                            .frame(width: 70, height: 3)
                            .opacity(currentTab == .sets ? 1 : 0)
                    }
                }
                
                Button {
                    currentTab = .cards
                } label: {
                    VStack(spacing: 7) {
                        Text("Cards")
                        Rectangle()
                            .frame(width: 70, height: 3)
                            .opacity(currentTab == .cards ? 1 : 0)
                    }
                }
            }
            .padding(.bottom)
            .font(.system(size: 20, weight: .semibold))
        }
    }
    
    struct SearchBar: View {
        
        @Binding var searchText: String
        @Binding var isSearching: Bool
        @Binding var currentTab: Tab
        @FocusState var searchIsFocused: Bool
        
        let search: () -> ()
        
        var body: some View {
            HStack(spacing: 0) {
                TextField("", text: $searchText)
                    .font(.system(size: 20))
                    .tint(.white)
                    .foregroundStyle(.white)
                    .frame(height: 60)
                    .padding(.horizontal, 40)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.white.opacity(0.4))
                            .blendMode(.overlay)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass").font(.system(size: 18, weight: .medium)).opacity(searchText.isEmpty ? 0.4 : 1)
                                    Text("Search for \(currentTab == .sets ? "sets" : "cards")").opacity(searchText.isEmpty ? 0.4 : 0)
                                    Spacer()
                                }
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                                .padding(.leading, 10)
                            )
                    )
                    .keyboardType(.alphabet)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .focused($searchIsFocused)
                    .onTapGesture {
                        isSearching = true
                    }
                    .onChange(of: isSearching) {
                        searchIsFocused = isSearching
                    }
                    .onSubmit {
                        search()
                    }
            }
            .padding(.horizontal, 5)
            .padding(.bottom, -5)
        }
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

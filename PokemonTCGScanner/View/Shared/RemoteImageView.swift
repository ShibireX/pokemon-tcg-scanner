//
//  RemoteImageView.swift
//  Instant
//
//  Created by Andreas Garcia on 2024-01-20.
//

import SwiftUI

struct RemoteImageView: View {
    private var url: URL?
    private var placeholderColor: Color = .gray
    @State private var image: UIImage?
    @State private var loading: Bool
    private var fallbackImage: Image = Image("default-profile-picture")

    init(url: URL?) {
        self.url = url
        
        if let url {
            if let cachedImage = UIImage.cachedImage(forURL: url) {
                self._image = State(initialValue: cachedImage)
                self._loading = State(initialValue: false)
            } else {
                self._image = State(initialValue: nil)
                self._loading = State(initialValue: true)
            }
        } else {
            self._image = State(initialValue: nil)
            self._loading = State(initialValue: false)
        }
    }
    
    init(_ remoteImageUrl: URL?) {
        self.url = remoteImageUrl
        
        if let url {
            if let cachedImage = UIImage.cachedImage(forURL: url) {
                self._image = State(initialValue: cachedImage)
                self._loading = State(initialValue: false)
            } else {
                self._image = State(initialValue: nil)
                self._loading = State(initialValue: true)
            }
        } else {
            self._image = State(initialValue: nil)
            self._loading = State(initialValue: false)
        }
    }

    func loadRemote() async throws {
        if self.image == nil, let url {
            let loadedImage = try await UIImage.load(fromURL: url)
            self.image = loadedImage
        }
    }
    
    var body: some View {
        SwiftUI.Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if loading {
                LoadingIndicatorView(controlSize: .small)
            } else {
                LoadingIndicatorView(controlSize: .small)
            }
        }
        .geometryGroup()
        .task {
            try? await loadRemote()
            loading = false
        }
        .onChange(of: url) { oldUrl, newUrl in
            image = nil
            loading = true
            Task {
                try? await loadRemote()
                loading = false
            }
        }
    }
}

#Preview {
    RemoteImageView(url: URL(string: "https://images.pokemontcg.io/sv8/1_hires.png")!)
}

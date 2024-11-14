//
//  ScanView.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import SwiftUI
import AVFoundation

/*
 
 Logic:
 
 1. Get the XX/YY string
 2. Fetch all cards that correspond to the number in the particular set with that number of printedTotal (e.g. https://api.pokemontcg.io/v2/cards?q=set.printedTotal:198%20number:41)
 3. If more than one result, compare with fuzzy string matching of the entire recognized text from the scan against the resulting cards, and choose the best candidate
 
 */

struct ScanView: View {
    
    @ObservedObject var model: ScanViewModel = ScanViewModel()

    @State var shouldCapturePhoto: Bool = false
    @State var capturedPhoto: UIImage?
    @State var showCardDetailView: Bool = false
    @State var showHint: Bool = false
    @State var hintOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            withAnimation(.spring(duration: 1)) {
                                showHint = true
                                
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                withAnimation {
                                    showHint = false
                                }
                            }
                        } label: {
                            Image(systemName:"info.circle.fill")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.trailing, 40)
                .padding(.bottom, 20)
                                
                CameraFrameView(shouldCapturePhoto: $shouldCapturePhoto, capturedImage: $capturedPhoto, showHint: $showHint)
                Spacer()
                
                ZStack(alignment: .bottomTrailing) {
                    Button {
                        shouldCapturePhoto = true
                    } label: {
                        Image(systemName: "camera.aperture")
                            .font(.system(size: 70, weight: .light))
                    }
                    .disabled(shouldCapturePhoto || showHint)
                    .opacity(shouldCapturePhoto ? 0.2 : 1)
                    
                    if showHint {
                        Image(systemName: "hand.point.up.left.fill")
                            .font(.system(size: 60))
                            .transition(.opacity)
                            .shadow(color: .black, radius: 10)
                            .offset(x: 20 - hintOffset, y: 40 - hintOffset)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                        hintOffset = 10
                                    }
                                }
                            }
                    }
                }
                
                Spacer()
                Spacer()
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mainColor)
            .onChange(of: capturedPhoto) {
                if let capturedPhoto = capturedPhoto {
                    DispatchQueue.main.async(qos: .background) {
                        Task {
                            await model.identifyCard(uiImage: capturedPhoto)
                        }
                    }
                }
            }
            .onReceive(model.$identifiedCard) { card in
                if card != nil {
                    showCardDetailView = true
                    self.capturedPhoto = nil
                    shouldCapturePhoto = false
                }
            }
            .navigationDestination(isPresented: $showCardDetailView) {
                if let card = model.identifiedCard {
                    CardDetailView(card: card)
                        .onDisappear {
                            model.identifiedCard = nil
                        }
                }
            }
            .onTapGesture {
                withAnimation {
                    showHint = false
                }
            }
        }
        .tint(.white)
    }
    
    
    
    struct CameraFrameView: View {
        @Binding var shouldCapturePhoto: Bool
        @Binding var capturedImage: UIImage?
        @Binding var showHint: Bool
        
        @State private var isCameraAuthorized = false
        @State private var showAlert = false
                
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 22)
                    .inset(by: -1)
                    .stroke(.white.blendMode(.overlay), lineWidth: 1)
                    .foregroundStyle(.clear)
                    .aspectRatio(1/sqrt(2), contentMode: .fit)
                    .overlay(
                        GeometryReader { geometry in
                            ZStack {
                                if let capturedImage = capturedImage {
                                    Image(uiImage: capturedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipShape(RoundedRectangle(cornerRadius: 22))
                                    
                                } else {
                                    if isCameraAuthorized {
                                        CameraView(shouldCapturePhoto: $shouldCapturePhoto) { image in
                                            self.capturedImage = image
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 22))
                                    }
                                }
                                
                                if showHint {
                                    Image("latiasExample")
                                        .resizable()
                                        .scaledToFit()
                                        .scaleEffect(0.85)
                                        .transition(.scale.combined(with: .opacity))
                                }
                                
                            }
                        }
                    )
                    .padding(.horizontal, 40)
            }
            .onAppear {
                //checkCameraPermission()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Camera Access Denied"),
                    message: Text("Please enable camera access in settings."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        
        private func checkCameraPermission() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                isCameraAuthorized = true
            case .notDetermined:
                requestCameraPermission()
            default:
                showAlert = true
            }
        }
        
        private func requestCameraPermission() {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isCameraAuthorized = true
                    } else {
                        showAlert = true
                    }
                }
            }
        }
        
    }
    
}

#Preview {
    ScanView()
}

//
//  CameraViewController.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var photoOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var capturedPhoto: ((UIImage?) -> Void)?

    var currentCameraPosition: AVCaptureDevice.Position = .back

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop the capture session to release resources
        if captureSession.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.captureSession.stopRunning()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo

        setupCamera(currentCameraPosition)

        photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.addOutput(photoOutput)

        captureSession.commitConfiguration()

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
    }

    func setupCamera(_ position: AVCaptureDevice.Position) {
        captureSession.beginConfiguration()
        
        // Remove existing inputs
        if let currentInput = captureSession.inputs.first {
            captureSession.removeInput(currentInput)
        }

        // Add new input
        guard let videoDevice = camera(with: position) else { return }
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                currentCameraPosition = position
                
                // Lock configuration to set zoom factor
                try videoDevice.lockForConfiguration()
                
                // Set a zoom factor to simulate the subject appearing closer from a further distance
                let targetZoomFactor: CGFloat = 2.0 // Adjust this value as needed
                if videoDevice.activeFormat.videoMaxZoomFactor >= targetZoomFactor {
                    videoDevice.videoZoomFactor = targetZoomFactor
                }
                
                videoDevice.unlockForConfiguration()
            }
        } catch {
            print("Error setting up camera input: \(error)")
            return
        }
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    func camera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: position
        ).devices
        return devices.first
    }

    func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    func flipCamera() {
        let newPosition: AVCaptureDevice.Position = (currentCameraPosition == .back) ? .front : .back
        setupCamera(newPosition)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let photoData = photo.fileDataRepresentation() else {
            capturedPhoto?(nil)
            return
        }
        let image = UIImage(data: photoData)
        capturedPhoto?(image)
    }
}

struct CameraView: UIViewControllerRepresentable {
    class Coordinator: NSObject {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }
    }

    @Binding var shouldCapturePhoto: Bool
    var capturedPhoto: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.capturedPhoto = capturedPhoto
        return cameraViewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        if shouldCapturePhoto {
            uiViewController.takePhoto()
        }
    }
}

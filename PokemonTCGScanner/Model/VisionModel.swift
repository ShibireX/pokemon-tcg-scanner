//
//  VisionModel.swift
//  PokemonTCGScanner
//
//  Created by Andreas Garcia on 2024-11-10.
//

import Vision
import VisionKit

func recognizeText(from image: UIImage) -> String {
    guard let cgImage = image.cgImage else { return "" }
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    var recognizedText = ""

    let request = VNRecognizeTextRequest { (request, error) in
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
        for observation in observations {
            if let topCandidate = observation.topCandidates(1).first {
                recognizedText += topCandidate.string + " "
            }
        }
    }

    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true

    do {
        try requestHandler.perform([request])
    } catch {
        print("Error recognizing text: \(error)")
    }
    
    return recognizedText
}

func extractSetValues(text: String) -> (Int, Int) {
    let pattern = #"\b\d{1,3}/\d{1,3}\b"#
    var setValueString = ""
    var cardNumber: Int = 0
    var totalSetPrints: Int = 0

    if let regex = try? NSRegularExpression(pattern: pattern) {
        let range = NSRange(text.startIndex..., in: text)
        
        if let match = regex.firstMatch(in: text, options: [], range: range) {
            if let matchedRange = Range(match.range, in: text) {
                setValueString = String(text[matchedRange])
            }
        }
    }
        
    let splitSetValues = setValueString.split(separator: "/")
    if splitSetValues.count == 2 {
        cardNumber = Int(splitSetValues[0])!
        totalSetPrints = Int(splitSetValues[1])!
    }
    
    return (cardNumber, totalSetPrints)
}

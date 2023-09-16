//
//  OCRVision.swift
//  FinSight
//
//  Created by Yunseo Lee on 9/16/23.
//
import SwiftUI
import Vision

class OCRViewModel: ObservableObject {

    func recognizeText(in ciImage: CIImage, completion: @escaping (String?) -> Void) {
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            completion(recognizedStrings.joined(separator: "\n"))
        }
        
        request.recognitionLevel = .accurate
        let requests = [request]
        
        do {
            try VNImageRequestHandler(ciImage: ciImage, options: [:]).perform(requests)
        } catch {
            print("Error: \(error)")
            completion(nil)
        }
    }
    
    func detectDocument(in ciImage: CIImage) -> Bool {
        let request = VNDetectRectanglesRequest()
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
            let results = request.results ?? []
            return !results.isEmpty
        } catch {
            print("Error: \(error)")
            return false
        }
    }

}

struct OCRView: View {
    @State private var selectedImage: UIImage? = nil
    @ObservedObject var viewModel = OCRViewModel()

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            Button("Select Image") {
                // Implement image picker functionality here
                // After selecting the image, call viewModel.recognizeText(from: selectedImage)
            }

//            Text(viewModel.recognizedText)
//                .padding()
        }
    }
}

struct OCRView_Previews: PreviewProvider {
    static var previews: some View {
        OCRView()
    }
}

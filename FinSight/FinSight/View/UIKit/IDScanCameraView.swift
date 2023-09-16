////
////  IDScanCameraView.swift
////  FinSight
////
////  Created by Yunseo Lee on 9/16/23.
////
//
//import UIKit
//import AVFoundation
//import Vision
//
///// Camera view displays the ui for taking front and back photos of the id scan
//final class IDScanCameraView: UIView {
//
//    private var captureSession: AVCaptureSession?
//    private var previewLayer: AVCaptureVideoPreviewLayer?
//    private var photoOutput = AVCapturePhotoOutput()
//    private var photoSettings: AVCapturePhotoSettings?
//
//    /// Setup the captureSession input which is the camera feed
//    private func setupInput() {
//        var backCamera: AVCaptureDevice?
//
//        /// Get back camera
//        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
//            backCamera = device
//        } else {
//            fatalError("Back camera could not be found")
//        }
//
//        /// Enable continuous auto focus
//        do {
//            try backCamera?.lockForConfiguration()
//            backCamera?.focusMode = .continuousAutoFocus
//            backCamera?.unlockForConfiguration()
//        } catch {
//            fatalError("Camera lockConfiguration failed")
//        }
//
//        /// Create input from our device
//        guard let backCamera = backCamera, let backCameraInput = try? AVCaptureDeviceInput(device: backCamera) else {
//            fatalError("Could not create device input from back camera")
//        }
//
//        if let captureSession = captureSession, !captureSession.canAddInput(backCameraInput) {
//            fatalError("could not add back camera input to capture session")
//        }
//
//        captureSession?.addInput(backCameraInput)
//    }
//    
//    /// Setup the captureSession output which is responsible for the generated pictures
//    private func setupOutput() {
//      /// Use HEVC as codec if available to save file space and maintain quality
//      if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
//        photoSettings = AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.hevc])
//      } else {
//        photoSettings = AVCapturePhotoSettings()
//      }
//
//      if let captureSession = captureSession, captureSession.canAddOutput(photoOutput) {
//        captureSession.addOutput(photoOutput)
//      }
//    }
//    
//    /// Setup and start the captureSession
//    func setupCaptureSession() {
//        captureSession = AVCaptureSession()
//        captureSession?.beginConfiguration()
//
//        if let captureSession = captureSession, captureSession.canSetSessionPreset(.photo) {
//          captureSession.sessionPreset = .photo
//        }
//
//        setupInputs()
//        setupOutput()
//        setupPreviewLayer()
//
//        captureSession?.commitConfiguration()
//
//        /// Start of the capture session must be executed in the background thread
//        /// by our extension function so the UI is not blocked in the main thread
//        DispatchQueue.background(background: { [weak self] in
//          self?.captureSession?.startRunning()
//        })
//    }
//    
//    func perspectiveCorrectedImage(from inputImage: CIImage, rectangleObservation: VNRectangleObservation ) -> CIImage? {
//        let imageSize = inputImage.extent.size
//
//        /// Verify detected rectangle is valid
//        let boundingBox = rectangleObservation.boundingBox.scaled(to: imageSize)
//        guard inputImage.extent.contains(boundingBox)
//        else { print("invalid detected rectangle"); return nil}
//
//        /// Rectify the detected image and reduce it to inverted grayscale for applying model
//        let topLeft = rectangleObservation.topLeft.scaled(to: imageSize)
//        let topRight = rectangleObservation.topRight.scaled(to: imageSize)
//        let bottomLeft = rectangleObservation.bottomLeft.scaled(to: imageSize)
//        let bottomRight = rectangleObservation.bottomRight.scaled(to: imageSize)
//        let correctedImage = inputImage
//            .cropped(to: boundingBox)
//            .applyingFilter("CIPerspectiveCorrection", parameters: [
//                "inputTopLeft": CIVector(cgPoint: topLeft),
//                "inputTopRight": CIVector(cgPoint: topRight),
//                "inputBottomLeft": CIVector(cgPoint: bottomLeft),
//                "inputBottomRight": CIVector(cgPoint: bottomRight)
//            ])
//        return correctedImage
//    }
//
//    /// Detects the document in the image and cuts out the background
//    func cropDocumentOut(from image: CIImage) {
//        let requestHandler = VNImageRequestHandler(ciImage: image)
//        let documentDetectionRequest = VNDetectDocumentSegmentationRequest()
//
//        do {
//            try requestHandler.perform([documentDetectionRequest])
//        } catch {
//            fatalError("Error while performing documentDetectionRequest")
//        }
//
//        guard let document = documentDetectionRequest.results?.first,
//              let documentImage = perspectiveCorrectedImage(from: image, rectangleObservation: document)?.convertToCGImage() else {
//            fatalError("Unable to get document image")
//        }
//
//        /// Save our captured photo of the id
//        idBackImage = UIImage(cgImage: documentImage)
//    }
//}

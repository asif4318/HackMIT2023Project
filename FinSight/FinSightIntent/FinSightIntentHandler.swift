//
//  FinSightIntentHandler.swift
//  FinSight
//
//  Created by Yunseo Lee on 9/17/23.
//

import Foundation
class FinSightIntentHandler: NSObject, FinsightIntentIntentHandling {
    
    let camera = Camera()
    let model = DataModel()
    
    func confirm(intent: FinsightIntentIntent, completion: @escaping (FinsightIntentIntentResponse) -> Void) {
        // You can add any pre-checks here before confirming the intent.
        completion(FinsightIntentIntentResponse(code: .ready, userActivity: nil))
    }
    
    func handle(intent: FinsightIntentIntent, completion: @escaping (FinsightIntentIntentResponse) -> Void) {
        Task {
            // 1. Take photo
            camera.takePhoto()
            
            // 2. Recognize text from the photo
            // Assuming handleCameraPhotos() is modified to return recognized text
//            await model.handleCameraPhotos()
            
            // 3. Send recognized text to API and fetch output
            let output = model.fetchOutput()
            
            // 4. Return the output to SiriKit
            if output != "No API output" {
                completion(FinsightIntentIntentResponse.success(apiResponse: output))
            } else {
                print("failed API on FinSightHandler")
            }
        }
    }
}

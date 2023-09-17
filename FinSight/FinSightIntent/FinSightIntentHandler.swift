//
//  FinSightIntentHandler.swift
//  FinSightIntent
//
//  Created by Yunseo Lee on 9/17/23.
//

import Foundation

class FinSightIntentHandler: NSObject, FinSightIntentHandling {
    
    func confirm(intent: FinSightIntent, completion: @escaping (FinSightIntentResponse) -> Void) {
        // You can add any pre-checks here before confirming the intent.
        completion(FinSightIntentResponse(code: .ready, userActivity: nil))
    }
    
    func handle(intent: FinSightIntent, completion: @escaping (FinSightIntentResponse) -> Void) {
        let output = ""
        Task {
            if output != "No API output" {
                completion(FinSightIntentResponse.success(apiResponse: output))
            } else {
                print("Failed FinSightHandler")
            }
        }
    }
}

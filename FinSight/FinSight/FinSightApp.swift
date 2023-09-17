//
//  FinSightApp.swift
//  FinSight
//
//  Created by Yunseo Lee on 9/16/23.
//

import SwiftUI
import Intents
@main
struct FinSightApp: App {
    @Environment(\.scenePhase) private var scenePhase
    init() {
        UINavigationBar.applyCustomAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            CameraView()
        }.onChange(of: scenePhase) { phase in
            INPreferences.requestSiriAuthorization({status in
                print("Error requesting Siri Access")
            })
        }
    }
}


fileprivate extension UINavigationBar {
    
    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

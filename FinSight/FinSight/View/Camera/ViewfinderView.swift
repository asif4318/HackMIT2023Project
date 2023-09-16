//
//  ViewfinderView.swift
//  FinSight
//
//  Created by Yunseo Lee on 9/16/23.
//

import SwiftUI

struct ViewfinderView: View {
    @Binding var image: Image?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

//struct ViewfinderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewfinderView(image: .constant(Image(systemName: "pencil")))
//    }
//}


//
//  MediaView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/7/23.
//

import SwiftUI
import Kingfisher

struct MediaView: View {
    var mediaImage: UIImage
    var body: some View {
       Image(uiImage: mediaImage)
            .resizable()
    }
}

//#Preview {
//    MediaView()
//}

//
//  MediaView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/7/23.
//

import SwiftUI
import Kingfisher

struct MediaView: View {
    var media: Media
    var body: some View {
        KFImage.url(URL(string: media.unwrappedURL))
            .resizable()
            .placeholder({
                ProgressView()
            })
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { result in  }
            .onFailure { error in }
    }
}

//#Preview {
//    MediaView()
//}

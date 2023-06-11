//
//  FrameViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/6/23.
//

import Foundation
import SwiftUI
import Kingfisher

class FrameViewModel: ObservableObject {
    static let shared = FrameViewModel()
    
    private init() { }
    
    func getFrameImage(frame: Frame? = nil) -> Image? {
        if let frame = frame {
            guard let frameID = frame.unique_id else {
                return Image(systemName: "photo")
            }
            guard let frameImage = ImageCache.default.retrieveImageInMemoryCache(forKey: frameID) else {
                return Image(systemName: "photo")
            }
            return Image(uiImage: frameImage)
        }
        return nil
    }
}

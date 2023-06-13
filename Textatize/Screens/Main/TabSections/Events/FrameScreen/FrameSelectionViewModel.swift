//
//  FrameSelectionViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/9/23.
//

import SwiftUI
import Kingfisher

class FrameSelectionViewModel: ObservableObject {
    
    static let shared = FrameSelectionViewModel()
    
    @Published var frames = [Frame]()
    
    let textatizeAPI = TextatizeAPI.shared
    
    private init() {
        
    }
    
    func getFrames(orientation: Orientation) {
        textatizeAPI.retrieveFrames(orientation: orientation) { [weak self] error, framesResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let framesResponse = framesResponse, let apiFrames = framesResponse.frames {
                self.frames = apiFrames
            }
        }
    }
    
    func getFrameImage(frame: Frame? = nil) -> Image {
        if let frame = frame {
            guard let frameID = frame.unique_id else {
                return Image(systemName: "photo")
            }
            guard let frameImage = ImageCache.default.retrieveImageInMemoryCache(forKey: frameID) else {
                return Image(systemName: "photo")
            }
            return Image(uiImage: frameImage)
        }
        return Image(systemName: "photo")
    }
    
}

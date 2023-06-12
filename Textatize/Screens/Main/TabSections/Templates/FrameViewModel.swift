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
    
    private let textatizeAPI = TextatizeAPI.shared
    
    @Published var frames = [Frame]()
    
    private init() {
        fetchFrames()
    }
    
    func refreshFrames() {
        fetchFrames()
    }
    
    private func fetchFrames() {
        textatizeAPI.retrieveFrames(orientation: nil) { [weak self] error, framesResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let framesResponse = framesResponse, let apiFrames = framesResponse.frames {
                self.cacheFrameImages(downloadedFrames: apiFrames)
            }
        }
    }
    
    private func cacheFrameImages(downloadedFrames: [Frame]) {
        for frame in downloadedFrames {
            guard let frameURL = URL(string: frame.unwrappedURL) else { return }
            guard let frameID = frame.unique_id else { return }
            KingfisherManager.shared.retrieveImage(with: frameURL) { result in
                switch result {
                case .success(let value):
                    ImageCache.default.store(value.image, forKey: frameID)
                    print("Frame Cached: \(ImageCache.default.isCached(forKey: frameID))")
                    if !self.frames.contains(frame) {
                        self.frames.append(frame)
                    }
                    
                case .failure(let error):
                    print("Error Downloading Image: \(error.localizedDescription)")
                }
            }
        }
    }
    
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

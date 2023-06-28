//
//  FrameViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/6/23.
//

import Foundation
import SwiftUI
import Kingfisher

enum FramesType {
    case frame, custom
}

class FrameViewModel: ObservableObject {
    static let shared = FrameViewModel()
    
    private let textatizeAPI = TextatizeAPI.shared
    
    @Published var frames = [Frame]()
    @Published var customFrames = [Frame]()
    
    private init() {
        refreshFrames()
    }
    
    func refreshFrames() {
        retrieveFrames()
        retrieveMyFrames()
    }
    
    private func retrieveMyFrames() {
        textatizeAPI.retrieveMyFrames(orientation: nil, page: "0") { error, framesResponse in
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let framesResponse = framesResponse, let apiFrames = framesResponse.frames {
                self.customFrames = apiFrames

                //self.cacheFrameImages(downloadedFrames: apiFrames, type: .custom)
            }
        }
    }
    
    private func retrieveFrames() {
        textatizeAPI.retrieveFrames(orientation: nil) { [weak self] error, framesResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let framesResponse = framesResponse, let apiFrames = framesResponse.frames {
                self.frames = apiFrames
            }
        }
    }

}

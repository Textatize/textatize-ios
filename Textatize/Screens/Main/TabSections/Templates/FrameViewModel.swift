//
//  FrameViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/6/23.
//

import Foundation

class FrameViewModel: ObservableObject {
    static let shared = FrameViewModel()
    
    @Published var frames = [Frame]()
    
    let textatizeAPI = TextatizeAPI.shared
    
    private init() {
     
        textatizeAPI.retrieveFrames(orientation: nil) { [weak self] error, framesResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let framesResponse = framesResponse, let frames = framesResponse.frames {
                self.frames = frames
                print("Completed Frames")
            }
        }
        
    }
    
    public func getFrameURL(frame: Frame) -> URL? {
        return URL(string: frame.unwrappedURL)
    }
}

//
//  FrameViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/7/23.
//

import SwiftUI

class FrameSelectionViewModel: ObservableObject {
    
    static let shared = FrameSelectionViewModel()
    
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
    
}

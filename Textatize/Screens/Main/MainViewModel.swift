//
//  MainViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/7/23.
//

import SwiftUI
import Kingfisher

class MainViewModel: ObservableObject {
    static let shared = MainViewModel()
    
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
                //cacheFrame(cFrame: frames)
                print("Completed Frames")
            }
        }
        
    }
    
    
}



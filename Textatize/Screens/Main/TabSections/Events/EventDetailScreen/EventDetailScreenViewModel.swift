//
//  EventDetailScreenViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/7/23.
//

import Foundation

class EventDetailScreenViewModel: ObservableObject {
    static let shared = EventDetailScreenViewModel()
    
    @Published var medias = [Media]()
    @Published var frames = [Frame]()
    
    let textatizeAPI = TextatizeAPI.shared

    
    private init() { }
    
    func getMedia(event: Event) {
        if let eventId = event.unique_id {
            textatizeAPI.retrieveMedia(page: nil, eventID: eventId) { [weak self] error, mediaResponse in
                guard let self = `self` else { return }
                
                if let error = error {
                    print(error.getMessage() ?? "No Message Found")
                }
                
                if let mediaResponse = mediaResponse, let APIMedias = mediaResponse.medias {
                    self.medias = APIMedias
                    print("Media For \(eventId)")
                    print(medias.count)
                }
            }
        }
        
    }
    
    func getFrames(orientation: Orientation?, page: String?) {
        textatizeAPI.retrieveFrames(orientation: orientation) { [weak self] error, framesResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let framesResponse = framesResponse, let APIFrames = framesResponse.frames {
                self.frames = APIFrames
                print("Frames Success")
                print(frames.count)
            }
        }
    }
}

//
//  CheckInfoViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/24/23.
//

import Foundation
import SwiftUI
import Kingfisher

class CheckInfoViewModel: ObservableObject {
    
    let api = TextatizeAPI.shared
    let eventVM = EventViewModel.shared
    
    func createEvent(name: String, hostName: String?, date: String?, orientation: Orientation, camera: Camera, watermarkPosition: WatermarkPosition, location: String, watermarkImage: UIImage?, watermarkTransparency: String, frame: Frame?, useFrame: String) {
        
        
        api.createEvent(name: name, hostName: hostName, date: date, orientation: orientation, camera: camera, watermarkPosition: watermarkPosition, location: location, watermarkImage: watermarkImage, watermarkTransparency: watermarkTransparency, frame: frame, useFrame: useFrame) { error, eventResponse in
            if let error = error {
                print("Error: \(error)")
            }
            
            if let eventResponse = eventResponse {
                print("EventResponse: \(eventResponse.event?.name)")
            }
            self.eventVM.refreshEvents()
        }
        
    }
    
    func updateEvent(eventID: String, date: String?, name: String, hostName: String, orientation: Orientation, camera: Camera, watermarkPosition: WatermarkPosition, location: String, watermarkImage: UIImage?, watermarkTransparency: String, frame: Frame?, useFrame: String) {
        api.updateEvent(eventID: eventID, name: name, hostName: hostName, date: date, orientation: orientation, camera: camera, watermarkPosition: watermarkPosition, location: location, watermarkImage: watermarkImage, watermarkTransparency: watermarkTransparency, frame: frame, useFrame: useFrame) { error, eventResponse in
            if let error = error {
                print("Error: \(error)")
            }
            
            if let eventResponse = eventResponse {
                print("EventResponse: \(eventResponse.event?.name)")
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

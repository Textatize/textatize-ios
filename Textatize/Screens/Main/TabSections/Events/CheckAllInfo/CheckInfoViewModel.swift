//
//  CheckInfoViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/24/23.
//

import Foundation
import SwiftUI

class CheckInfoViewModel: ObservableObject {
    
    let api = TextatizeAPI.shared
    
    func createEvent(name: String, orientation: Orientation, camera: Camera, watermarkPosition: WatermarkPosition, location: String, watermarkImage: UIImage?, watermarkTransparency: String, frame: Frame?) {
        
        
        api.createEvent(name: name, orientation: orientation, camera: camera, watermarkPosition: watermarkPosition, location: location, watermarkImage: watermarkImage, watermarkTransparency: watermarkTransparency, frame: frame) { [weak self] error, eventResponse in
            if let error = error {
                print("Error: \(error)")
            }
            
            if let eventResponse = eventResponse {
                print("EventResponse: \(eventResponse.event?.name)")
            }
        }
        
    }
    
}

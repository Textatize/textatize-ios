//
//  MainEventViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/24/23.
//

import SwiftUI

class EventViewModel: ObservableObject {
    
    @Published var firstName = DataManager.shared.user?.firstName ?? "No Name"
    
    @Published var eventName = ""
    @Published var eventHostName = ""
    @Published var eventLocation = ""
    @Published var orientation: Orientation = .portrait
    @Published var camera: Camera = .back
    @Published var watermarkPosition: WatermarkPosition = .bottomLeft
    @Published var watermarkTransparency = 0.00
    @Published var watermarkImage: UIImage? = UIImage(systemName: "person")
}

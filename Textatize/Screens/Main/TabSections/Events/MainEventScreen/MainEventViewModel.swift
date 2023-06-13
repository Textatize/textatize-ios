//
//  MainEventViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/24/23.
//

import SwiftUI

class EventViewModel: ObservableObject {
    
    static let shared = EventViewModel()
    
    @Published var firstName = TextatizeLoginManager.shared.loggedInUser?.firstName ?? "No Name Found"
    @Published var events = [Event]()
    @Published var completedEvents = [Event]()
    
    @Published var selectedEvent: Event? = nil
    
    @Published var editName: String = ""
    @Published var editDate: String = ""
    @Published var editLocation: String = ""
    @Published var editOrientation: Orientation = .portrait
    @Published var editCamera: Camera = .front
    @Published var editHostName: String = ""
    
    @Published var frameName: String = ""
    @Published var frameDate: String = ""
    @Published var frameLocation: String = ""
    @Published var frameOrientation: Orientation = .portrait
    @Published var FrameCamera: Camera = .front
    @Published var frameHostName: String = ""
    @Published var frameWatermarkPosition: WatermarkPosition = .bottomRight
    @Published var frameWatermarkTransparency: Double = 0.0
    @Published var selectedFrame: Frame? = nil

    
    let textatizeAPI = TextatizeAPI.shared
    let defaults = UserDefaults.standard
    
    
    
    private init() {
        textatizeAPI.retrieveEvents(status: .active, page: nil) { [weak self] error, eventsResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let eventsResponse = eventsResponse, let APIEvents = eventsResponse.events {
                self.events = APIEvents
                print("Active Events")
            }
        }
        
        textatizeAPI.retrieveEvents(status: .completed, page: nil) { [weak self] error, eventsResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let eventsResponse = eventsResponse, let APIEvents = eventsResponse.events {
                self.completedEvents = APIEvents
                print("Completed Events")
            }
        }
    }
    
    func refreshEvents() {        
        textatizeAPI.retrieveEvents(status: .active, page: nil) { [weak self] error, eventsResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let eventsResponse = eventsResponse, let APIEvents = eventsResponse.events {
                self.events = APIEvents
                print("Active Events")
            }
        }
        
        textatizeAPI.retrieveEvents(status: .completed, page: nil) { [weak self] error, eventsResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let eventsResponse = eventsResponse, let APIEvents = eventsResponse.events {
                self.completedEvents = APIEvents
                print("Completed Events")
            }
        }
    }
    
}

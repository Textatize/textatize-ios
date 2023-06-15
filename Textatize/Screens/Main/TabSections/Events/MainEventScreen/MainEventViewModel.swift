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
    
    @Published var name: String = ""
    @Published var date: String = ""
    @Published var location: String = ""
    @Published var orientation: Orientation = .portrait
    @Published var camera: Camera = .front
    @Published var hostName: String = ""
    @Published var watermarkPosition: WatermarkPosition = .bottomRight
    @Published var watermarkTransparency: Double = 0.0
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
    
    func deleteEvent(event: Event) {
        if let eventID = event.unique_id {
            textatizeAPI.deleteEvent(eventID: eventID) { error, success in
                if let error = error {
                    print(error.getMessage() ?? "No Message Found")
                }
                
                if success {
                    self.refreshEvents()
                }
                
            }
        }
    }
    
    func completeEvent(event: Event) {
        if let eventID = event.unique_id {
            textatizeAPI.completeEvent(eventID: eventID) { error, success in
                if let error = error {
                    print(error.getMessage() ?? "No Message Found")
                }
                
                if success {
                    self.refreshEvents()
                }
            }
        }
    }
    
}

//
//  MainEventViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/24/23.
//

enum AddOn {
    case frame, watermark
}

import SwiftUI
import Kingfisher

class EventViewModel: ObservableObject {
    
    static let shared = EventViewModel()
    
    @Published var firstName = TextatizeLoginManager.shared.loggedInUser?.firstName ?? "No Name Found"
    
    @Published var selectedEvent: Event? = nil
    
    @Published var name: String = ""
    @Published var date: String? = nil
    @Published var location: String = ""
    @Published var orientation: Orientation = .portrait
    @Published var camera: Camera = .front
    @Published var hostName: String = ""
    @Published var watermarkPosition: WatermarkPosition = .bottomRight
    @Published var watermarkTransparency: Double = 0.0
    @Published var selectedFrame: Frame? = nil
    @Published var selectedWatermark: UIImage? = nil
    @Published var addon: AddOn? = nil
    
    @Published var activeEvents = [Event]()
    @Published var completedEvents = [Event]()
    
    let textatizeAPI = TextatizeAPI.shared
    let loginManager = TextatizeLoginManager.shared
    let defaults = UserDefaults.standard
    
    
    
    private init() {
        refreshEvents()
//        textatizeAPI.retrieveEvents(status: .active, page: nil) { [weak self] error, eventsResponse in
//            guard let self = `self` else { return }
//            
//            if let error = error {
//                print(error.getMessage() ?? "No Message Found")
//            }
////            
////            if let eventsResponse = eventsResponse, let APIEvents = eventsResponse.events {
////                self.events = APIEvents
////                print("Active Events")
////            }
//        }
//        
//        textatizeAPI.retrieveEvents(status: .completed, page: nil) { [weak self] error, eventsResponse in
//            guard let self = `self` else { return }
//            
//            if let error = error {
//                print(error.getMessage() ?? "No Message Found")
//            }
////            
////            if let eventsResponse = eventsResponse, let APIEvents = eventsResponse.events {
////                self.completedEvents = APIEvents
////                print("Completed Events")
////            }
//        }
    }
    
    func refreshEvents() {        
        textatizeAPI.retrieveEvents(status: .active, page: nil) { [weak self] error, eventsResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let eventsResponse = eventsResponse, let APIEvents = eventsResponse.events {
                self.activeEvents = APIEvents
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

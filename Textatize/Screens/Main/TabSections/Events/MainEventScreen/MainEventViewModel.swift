//
//  MainEventViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/24/23.
//

import SwiftUI

class EventViewModel: ObservableObject {
    
    static let shared = EventViewModel()
    
    @Published var firstName = DataManager.shared.user?.firstName ?? "No Name Found"
    @Published var events = [Event]()
    
    let textatizeAPI = TextatizeAPI.shared
    
    private init() {
        
        textatizeAPI.getEvent { [weak self] error, eventResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let eventResponse = eventResponse, let APIEvents = eventResponse.events {
                self.events = APIEvents
            }
            
            print("Event Count: \(events.count)")
            
        }
        
    }
    
    
}

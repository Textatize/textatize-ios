//
//  EventResponse.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import ObjectMapper

class EventsResponse: ServerResponse {
    var events: [Event]? = nil
    
    // MARK: ServerObject
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        events <- map["events"]
    }
    

}

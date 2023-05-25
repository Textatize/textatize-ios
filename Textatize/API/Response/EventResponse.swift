//
//  EventResponse.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/25/23.
//

import ObjectMapper

class EventResponse: ServerResponse {
    var event: Event? = nil
    
    // MARK: ServerObject
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        event <- map["event"]
    }
    

}

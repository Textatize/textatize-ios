//
//  Event.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import ObjectMapper

class Event: AbstractServerObject, Identifiable {
    
    var name:                   String?     = nil
    var status:                 String?     = nil
    var date:                   EventDate?  = nil
    var location:               String?     = nil
    var orientation:            String?     = nil
    var camera:                 String?     = nil
    var watermarkUrl:           String?     = nil
    var watermarkTransparency:  Double?     = nil
    var watermarkPosition:      String?     = nil
    var entityStatus:           String?     = nil
    var createdTime:            Int?        = nil
    var updatedTime:            Int?        = nil
    var createdFormatted:       String?     = nil
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name                    <- map["name"]
        status                  <- map["status"]
        date                    <- map["date"]
        location                <- map["location"]
        orientation             <- map["orientation"]
        camera                  <- map["camera"]
        watermarkUrl            <- map["watermarkUrl"]
        watermarkTransparency   <- map["watermarkTransparency"]
        watermarkPosition       <- map["watermarkPosition"]
        entityStatus            <- map["entityStatus"]
        createdTime             <- map["created_time"]
        updatedTime             <- map["updated_time"]
        createdFormatted        <- map["created_formatted"]
        
    }
    
}

class EventDate: AbstractServerObject {
    
    var year:  Int?  = nil
    var month: Int?  = nil
    var day:   Int?  = nil
    
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        year   <- map["year"]
        month  <- map["month"]
        day    <- map["day"]
    }
    
}

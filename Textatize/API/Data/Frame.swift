//
//  Frame.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/6/23.
//

import ObjectMapper

class Frame: AbstractServerObject, Identifiable {
    
    var orientation:        Orientation?    = nil
    var type:               FrameType?      = nil
    var url:                String?         = nil
    var entityStatus:       String?         = nil
    var created_time:       Int?            = nil
    var updated_time:       Int?            = nil
    var created_formatted:  String?         = nil
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        orientation         <- map["orientation"]
        type                <- map["type"]
        url                 <- map["url"]
        entityStatus        <- map["entityStatus"]
        created_time        <- map["created_time"]
        updated_time        <- map["updated_time"]
        created_formatted   <- map["created_formatted"]

    }
    
    var unwrappedURL: String {
        url ?? "No Url Found"
    }
    
}

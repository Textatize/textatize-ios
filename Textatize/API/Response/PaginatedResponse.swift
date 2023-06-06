//
//  PaginatedResponse.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/6/23.
//

import ObjectMapper

class PaginatedResponse: ServerResponse {
    var has_more: Bool = false
    var page: NSNumber? = nil

    // MARK: ServerObject
    
    override init() {
        super.init()
    }

    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        has_more <- map["has_more"]
        page <- map["page"]
    }

}

//
//  MediasResponse.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/25/23.
//

import ObjectMapper

class MediasResponse: ServerResponse {
    var page: Int? = nil
    var has_more: Bool? = nil
    var total_pages: Int? = nil
    var max_items_per_page: Int? = nil

    
    // MARK: ServerObject
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        page <- map["page"]
        has_more <- map["has_more"]
        total_pages <- map["total_pages"]
        max_items_per_page <- map["max_items_per_page"]

    }
    

}

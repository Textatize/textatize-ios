//
//  MediaResponse.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/5/23.
//

import ObjectMapper

class MediaResponse: ServerResponse {
    var media: Media? = nil
    
    // MARK: ServerObject
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        media <- map["media"]
    }
    

}

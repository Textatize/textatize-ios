//
//  MediasResponse.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/25/23.
//

import ObjectMapper

class MediasResponse: PaginatedResponse {
    var medias: [Media]? = nil
    
    // MARK: ServerObject
    
    override init() {
        super.init()
    }
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        medias <- map["medias"]


    }
    

}

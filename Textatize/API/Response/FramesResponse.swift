//
//  FramesResponse.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/6/23.
//

import ObjectMapper

class FramesResponse: PaginatedResponse {
    var frames: [Frame]? = nil
    
    // MARK: ServerObject
    
    override init() {
        super.init()
    }
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        frames <- map["frames"]


    }
    

}

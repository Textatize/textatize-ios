//
//  FrameResponse.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/6/23.
//

import ObjectMapper

class FrameResponse: ServerResponse {
    var frame: Frame? = nil
    
    // MARK: ServerObject
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        frame <- map["frame"]
    }
    

}

//
//  ServerResponse.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import ObjectMapper
import SwiftUI

class ServerResponse: NSObject, Mappable {
    
    var error: String? = nil
    var sessionToken: String? = nil
    
    override init() { }

    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        sessionToken <- map["sessionToken"]
        error <- map["error"]
    }
}

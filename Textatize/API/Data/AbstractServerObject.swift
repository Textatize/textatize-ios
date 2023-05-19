//
//  AbstractServerObject.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import ObjectMapper
import SwiftUI

class AbstractServerObject: NSObject, Mappable {
    
    var unique_id: String? = nil
    var created: String? = nil
    var created_date: Date? = nil
    
    override init() { }
    
    required init?(map: ObjectMapper.Map) { }
    
    func mapping(map: ObjectMapper.Map) {
        unique_id <- map["unique_id"]
        created <- map["created"]
        created_date <- (map["created_time"], DateTransform())
    }
    
    override func isEqual(_ object: Any?) -> Bool {
            return unique_id == (object as? AbstractServerObject)?.unique_id
        }
    
    
}

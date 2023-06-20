//
//  User.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import ObjectMapper

class User: AbstractServerObject {
    
    var firstName: String? = nil
    var lastName: String? = nil
    var username: String? = nil
    var email: String? = nil
    var phone: String? = nil
    var uniqueId: String? = nil
    var created1: String? = nil
    var entityStatus: String? = nil
    var createdTime: String? = nil
    var updatedTime: String? = nil
    var createdFormatted: String? = nil
    var isEmailVerified: Bool? = nil
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        username <- map["username"]
        email <- map["email"]
        phone <- map["phone"]
        uniqueId <- map["unique_id"]
        created1 <- map["created"]
        entityStatus <- map["entityStatus"]
        createdTime <- map["created_time"]
        updatedTime <- map["updated_time"]
        createdFormatted <- map["created_formatted"]
        isEmailVerified <- map["isEmailVerified"]
    }
    
    var getIsEmailVerified: Bool  {
        isEmailVerified ?? false
    }
    
}

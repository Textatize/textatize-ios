//
//  Event.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import ObjectMapper

class Event: AbstractServerObject, Identifiable {
    var name:                   String?     = nil
    var status:                 String?     = nil
    var date:                   EventDate?  = nil
    var frame:                  Frame?      = nil
    var location:               String?     = nil
    var orientation:            String?     = nil
    var numPhotos:              Int?        = nil
    var camera:                 String?     = nil
    var watermarkUrl:           String?     = nil
    var watermarkTransparency:  Double?     = nil
    var watermarkPosition:      String?     = nil
    var entityStatus:           String?     = nil
    var createdTime:            Int?        = nil
    var updatedTime:            Int?        = nil
    var createdFormatted:       String?     = nil
    var useFrame:               Bool?       = nil
    var hostName:               String?     = nil
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name                    <- map["name"]
        status                  <- map["status"]
        date                    <- map["date"]
        frame                   <- map["frame"]
        location                <- map["location"]
        orientation             <- map["orientation"]
        camera                  <- map["camera"]
        numPhotos               <- map["numPhotos"]
        watermarkUrl            <- map["watermarkUrl"]
        watermarkTransparency   <- map["watermarkTransparency"]
        watermarkPosition       <- map["watermarkPosition"]
        entityStatus            <- map["entityStatus"]
        createdTime             <- map["created_time"]
        updatedTime             <- map["updated_time"]
        createdFormatted        <- map["created_formatted"]
        useFrame                <- map["useFrame"]
        hostName                <- map["hostName"]
    }
    
    var getName: String {
        name ?? "No Name"
    }
    
    var getNumPhotos: Int {
        numPhotos ?? 0
    }
    
    var getDate: String? {
        
        var dateString = ""
        if let day = date?.day, let month = date?.month, let year = date?.year {
             return "\(month)/\(day)/\(year)"
        } else {
            return nil
        }
    }
    
    var getLocation: String {
        location ?? "No Location"
    }
    
    var getOrientation: Orientation {
        if orientation == Orientation.landscape.rawValue {
            return .landscape
        } else if orientation == Orientation.portrait.rawValue {
            return .portrait
        } else if orientation == Orientation.square.rawValue {
            return .square
        } else {
            return .portrait
        }
    }
    
    var getCamera: Camera {
        if camera == Camera.front.rawValue {
            return .front
        } else if camera == Camera.back.rawValue {
            return .back
        } else {
            return .back
        }
    }
    
    var getWatermarkUrl: String {
        watermarkUrl ?? "No WatermarkUrl"
    }
    
    var getWatermarkTransparency: Double {
        watermarkTransparency ?? 1.0
    }
    
    var getWatermarkPosition: WatermarkPosition {
        if watermarkPosition == WatermarkPosition.bottomLeft.rawValue {
            return .bottomLeft
        } else if watermarkPosition == WatermarkPosition.bottomRight.rawValue {
            return .bottomRight
        } else {
            return .bottomLeft
        }
    }
    
    var getUseFrame: Bool {
        useFrame ?? true
    }
    
    func cache() {
        CacheManager.shared.setObject(anObject: self, forKey: self.unique_id!)
        NotificationCenter.default.post(name:.updateEvent,
                                        object: nil,
                                        userInfo: ["object":self])
    }
}

class EventDate: AbstractServerObject {
    
    var year:  Int?  = nil
    var month: Int?  = nil
    var day:   Int?  = nil
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        year   <- map["year"]
        month  <- map["month"]
        day    <- map["day"]
    }
    
}

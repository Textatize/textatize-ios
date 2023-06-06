//
//  LocalImage.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/5/23.
//

import Foundation
import ObjectBox

class LocalImage: Entity {
    var id:                 Id          = 0
    var eventID:            String?     = nil
    var imageData:          Data?       = nil
    var unique_id:          String      = "\(UUID())"
    var created_time:       Int?        = nil
    var updated_time:       Int?        = nil
    var created_formatted:  String?     = nil
    var uploaded:           Bool        = false
    var markForUpload:      Int         = 0
}

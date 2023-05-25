//
//  EnumHelpers.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/24/23.
//

import Foundation

enum Orientation: String {
    case portrait = "portrait"
    case landscape = "landscape"
    case square = "square"
}

enum Camera: String {
    case front = "front"
    case back = "back"
}

enum WatermarkPosition: String {
    case bottomLeft = "bottomLeft"
    case bottomRight = "bottomRight"
}

enum EventStatus: String {
    case active = "active"
    case completed = "completed"
}

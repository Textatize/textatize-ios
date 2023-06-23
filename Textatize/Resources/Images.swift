//
//  Images.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/15/23.
//

import Foundation
import SwiftUI

extension UIImage: Identifiable {}

enum AppImages {
    
    static let editIcon = Image("edit icon")
    static let duplicateIcon = Image("Duplicate icon")
    static let checkSmall = Image("Check small")
    static let imageIcon = Image("Image icon")
    static let textIcon = Image("Text icon")
    static let diagramIcon = Image("Diagram")
    static let diagramFull = Image("Diagram full")
    static let position1 = Image("Position 1")
    static let position2 = Image("Position 2")

    
    enum Onboarding {
        static let checkIcon = Image("Check icon")
        static let eyeIcon = Image("Eye icon")
        static let smile = Image("Smile")
    }
    
    enum TabView {
        static let logo1 = Image("logo 1")
    }
    
    enum EventCard {
        static let plus = Image("Plus")
        static let plusSmall = Image("Plus small")
        static let arrow = Image("Arrow")
        static let arrowSmall = Image("arrow small")
        static let camera = Image("Camera")
    }
    
    enum settings {
        static let logo3 = Image("logo 3")
    }
}

extension UIImage {
    func resizeImage( size: CGSize) -> UIImage? {
            let scale: CGFloat = max(size.width / self.size.width, size.height / self.size.height)
            let width: CGFloat = self.size.width * scale
            let height: CGFloat = self.size.height * scale
            let imageRect = CGRect(x: (size.width - width) / 2.0, y: (size.height - height) / 2.0, width: width, height: height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            self.draw(in: imageRect)
            let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
}

//
//  FrameEditingViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/25/23.
//

import SwiftUI

class FrameEditingViewModel: ObservableObject {
    static let shared = FrameEditingViewModel()
    
    private init() { }
    
    func textToImage(drawText text: String, inImage image: UIImage, widthPercentage: CGFloat, heightPercentage: CGFloat, fontSizePercentage: Double, fontColor: UIColor) -> UIImage {
        let textFont = UIFont.systemFont(ofSize: image.size.width * fontSizePercentage)

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: fontColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

        let textWidth = text.widthOfString(usingFont: textFont)
        let textHeight = text.heightOfString(usingFont: textFont)
        
        let xPosition = (image.size.width - textWidth) * widthPercentage
        let yPosition = (image.size.height - textHeight) * heightPercentage
        
        let position = CGPoint(x: xPosition, y: yPosition)
        
        let rect = CGRect(origin: position, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
         let fontAttributes = [NSAttributedString.Key.font: font]
         let size = self.size(withAttributes: fontAttributes)
         return size.height
     }
    
}

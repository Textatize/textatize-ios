//
//  FrameEditHostVC.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/27/23.
//

import Foundation
import SwiftUI

struct HostedFrameEditViewController: UIViewControllerRepresentable {
    
    var frameImage: UIImage
    
    func makeUIViewController(context: Context) -> UIViewController {
        return ZLEditImageViewController(image: frameImage)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

//
//  CameraPreview.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/11/23.
//

import SwiftUI
import AVFoundation

class CameraPreviewViewcontroller: UIViewController {
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    private var screenRect: CGRect! = nil
    
    private var captureSession: AVCaptureSession
    private var deviceOrientation: Orientation
    
    init(captureSession: AVCaptureSession, deviceOrientation: Orientation) {
        self.captureSession = captureSession
        self.deviceOrientation = deviceOrientation
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.previewLayer.session = captureSession
        self.view.layer.addSublayer(self.previewLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRect = UIScreen.main.bounds
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        self.previewLayer.videoGravity = .resizeAspectFill

        switch deviceOrientation {
        case .portrait:
            self.previewLayer.connection?.videoOrientation = .portrait
        case .landscape:
            self.previewLayer.connection?.videoOrientation = .landscapeRight
        case .square:
            self.previewLayer.connection?.videoOrientation = .portrait
        }
        
    }
    
}


class CameraPreviewView: UIView {
    private var captureSession: AVCaptureSession
    
    init(session: AVCaptureSession) {
        self.captureSession = session
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
        
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if nil != self.superview {
            self.videoPreviewLayer.session = self.captureSession
            self.videoPreviewLayer.videoGravity = .resizeAspectFill
            //Setting the videoOrientation if needed
            //self.videoPreviewLayer.connection?.videoOrientation = .landscapeRight
        } else {
            self.videoPreviewLayer.session = nil
            self.videoPreviewLayer.removeFromSuperlayer()
        }
    }
}

struct HostedViewController: UIViewControllerRepresentable {
    
    var captureSesion: AVCaptureSession
    var deviceOrientation: Orientation
    
    func makeUIViewController(context: Context) -> UIViewController {
        return CameraPreviewViewcontroller(captureSession: captureSesion, deviceOrientation: deviceOrientation)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}


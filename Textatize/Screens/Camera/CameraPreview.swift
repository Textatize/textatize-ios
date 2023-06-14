//
//  CameraPreview.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/11/23.
//

import SwiftUI
import AVFoundation

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

struct CameraPreviewHolder: UIViewRepresentable {
    var captureSession: AVCaptureSession
    
    func makeUIView(context: UIViewRepresentableContext<CameraPreviewHolder>) -> CameraPreviewView {
        CameraPreviewView(session: captureSession)
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: UIViewRepresentableContext<CameraPreviewHolder>) {
    }
    
    typealias UIViewType = CameraPreviewView
}

//struct CameraPreview: UIViewRepresentable {
//    
//    @ObservedObject var camera: CameraModel
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView(frame: UIScreen.main.bounds)
//        
//        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
//        
//        camera.preview.frame = view.frame
//        
//        camera.preview.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(camera.preview)
//                
//        camera.session.startRunning()
//        
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        
//    }
//    
//}

//
//  CameraManager.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/14/23.
//

import AVFoundation
import SwiftUI
import Kingfisher

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}

class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    static let shared = CameraManager()
    
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    @Published var picData: Data?
    @Published var isTaken = false
    @Published var photoReady = false
    @Published var processedPhoto: UIImage?
    @Published var sessionRunning = false
    @Published var mediaShared = false
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var event: Event? = nil
    
    private let sessionQueue = DispatchQueue(label: "Textatize.SessionQueue")
    let textatizeAPI = TextatizeAPI.shared

    func check(orientation: AVCaptureDevice.Position) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setup(orientation: orientation)
            return
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] status in
                if status {
                    self.setup(orientation: orientation)
                    return
                }
            }
            
        default:
            break
        }
    }
    
    private func setup(orientation: AVCaptureDevice.Position) {
        do {
            self.session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: orientation) else { return }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            for item in session.inputs {
                session.removeInput(item)
            }
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
                        
            sessionQueue.async {
                self.session.startRunning()
                DispatchQueue.main.async {
                    self.sessionRunning = true
                }
            }
        } catch {
            print("Setup Error: \(error.localizedDescription)")
        }
        
    }
    
    func takePic() {
        withAnimation {
            self.photoReady = false
        }
        self.picData = nil
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
                    self.session.stopRunning()
                }
            }
        }
        
        DispatchQueue.main.async {
            withAnimation{
                self.isTaken.toggle()
                self.sessionRunning = false
            }
        }
    }
    
    func reTake() {
        withAnimation {
            self.photoReady = false
        }
        self.picData = nil
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                self.sessionRunning = true
            }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let error = error {
//            print("Photo Process Error: \(error)")
//            return
//        }
        
        print("Pic Taken...")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.picData = imageData
    }
    
    func downloadWatermark(event: Event, completion: @escaping ((UIImage) -> Void)) {
        guard let watermarkURL = URL(string: event.getWatermarkUrl) else { return }
        FileDownloader.shared.loadFileAsync(url: watermarkURL) { [weak self] path, error in
            guard let self = `self` else { return }
            
            if let error = error {
                print("Watermark Download Error: \(error)")
            }
            if let path = path {
                if let watermarkImage = UIImage(named: path) {
                    completion(watermarkImage)
                }
            }
        }
    }
    
    func downloadFrame(event: Event, completion: @escaping ((UIImage) -> Void)) {
        guard let frame = event.frame else { return }
        guard let frameURL = URL(string: frame.unwrappedURL) else { return }
        FileDownloader.shared.loadFileAsync(url: frameURL) { [weak self] path, error in
            guard let self = `self` else { return }

            if let error = error {
                print("Frame Download Error: \(error)")
            }
            if let path = path {
                if let frameImage = UIImage(named: path) {
                    completion(frameImage)
                }
            }
        }
    }

    func processPhotos() {
        
        guard let pictureData = self.picData else { return  }
        guard let saveImage = UIImage(data: pictureData) else { return }
        guard let event = event else { return }
        
        switch event.getUseFrame {
        case true:
            downloadFrame(event: event) { frameImage in
                
                let size = CGSize(width: frameImage.size.width, height: frameImage.size.height)
                UIGraphicsBeginImageContext(size)
                
                switch event.getOrientation {
                case .portrait:
                    saveImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                case .landscape:
                    let landscapeImage = saveImage.rotate(radians: event.getCamera == .front ? .pi / 2 : .pi / -2)
                    landscapeImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                case .square:
                    saveImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                }
                
                frameImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                self.processedPhoto = newImage ?? saveImage
                
                withAnimation {
                    self.photoReady = true
                }
            }
        case false:
            downloadWatermark(event: event) { watermarkImage in
                
                let alpha = event.getWatermarkTransparency
                let size = CGSize(width: watermarkImage.size.width, height: watermarkImage.size.height)
                UIGraphicsBeginImageContext(size)
                
                switch event.getOrientation {
                case .portrait:
                    saveImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                case .landscape:
                    let landscapeImage = saveImage.rotate(radians: event.getCamera == .front ? .pi / 2 : .pi / -2)
                    landscapeImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                case .square:
                    saveImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                }
                
                let watermarkImageHeight = size.height / 4
                let watermarkImageWidth = size.width / 4
                let watermarkImageYPosition = size.height - watermarkImageHeight - (watermarkImageHeight * 0.10)
                let watermarkImageHorizontalPadding = watermarkImageWidth * 0.10
                let watermarkImageLeftX = watermarkImageHorizontalPadding
                let watermarkImageRightX = size.width - watermarkImageWidth - (watermarkImageHorizontalPadding)
                
                switch event.getWatermarkPosition {
                case .bottomLeft:
                    watermarkImage.draw(in: CGRect(x: watermarkImageLeftX, y: watermarkImageYPosition, width: watermarkImageWidth, height: watermarkImageHeight), blendMode: .normal, alpha: alpha)
                    
                case .bottomRight:
                    watermarkImage.draw(in: CGRect(x: watermarkImageRightX, y: watermarkImageYPosition, width: watermarkImageWidth, height: watermarkImageHeight), blendMode: .normal, alpha: alpha)
                }
                
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                self.processedPhoto = newImage ?? saveImage
                
                withAnimation {
                    self.photoReady = true
                }
            }
        }
    }
    
    func retrieveImage() -> Data? {
        
        //guard let pictureData = self.picData else { return nil }
        
        //guard let saveImage = UIImage(data: pictureData) else { return nil }
        guard let processedPhoto = processedPhoto else { return nil }
        guard let imageData = processedPhoto.jpegData(compressionQuality: 0.5) else { return nil }
        //let finalImage = Image(uiImage: saveImage)
        
        print("Image Retrieve")
        return imageData
    }
    
    func addMedia(eventID: String, imageData: Data) {
        textatizeAPI.addMedia(eventID: eventID, imageData: imageData) { error, mediaResponse in
            if let error = error {
                print("Add Media Error: \(error)")
            }
        }
    }
    
    func shareMedia() {
        if let mediaID = UserDefaults.standard.object(forKey: "mediaID") as? String, let number = UserDefaults.standard.string(forKey: "shareNumber") as? String {
            TextatizeAPI.shared.shareMedia(phoneNumber: number, mediaID: mediaID) { error, success in
                if let error = error {
                    self.alertTitle     = "Share Media Error"
                    self.alertMessage   = error.getMessage() ?? "Error Sharing Media"
                    self.showAlert      = true
                }
                if let success = success, success {
                    self.mediaShared = true
                }
            }
        }
    }
    
}

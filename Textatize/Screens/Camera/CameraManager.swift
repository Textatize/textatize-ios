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

    func processPhotos(frame: Frame? = nil, watermarkString: String? = nil, position: WatermarkPosition? = nil, alpha: CGFloat? = nil) {
        
        guard let pictureData = self.picData else { return  }
        guard let saveImage = UIImage(data: pictureData) else { return }
        guard let event = event else { return }
        
        if let frame = frame {
            guard let frameURL = URL(string: frame.unwrappedURL) else { return }
            
            KingfisherManager.shared.retrieveImage(with: frameURL) { result in
                switch result {
                case .success(let value):
                    if let downloadedFrame = value.image.cgImage {
                        let size = CGSize(width: downloadedFrame.width, height: downloadedFrame.height)
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
                        
                        let frameImage = UIImage(cgImage: downloadedFrame)
                        frameImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                        
                        
                        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                            self.processedPhoto = newImage
                            withAnimation {
                                self.photoReady = true
                            }
                        } else {
                            self.processedPhoto = saveImage
                            withAnimation {
                                self.photoReady = true
                            }
                        }
                        
                    }
                case .failure:
                    print("Download Frame Failed")
                }
            }
        }
        
        if let watermarkString = watermarkString  {
            guard let watermarkURL = URL(string: watermarkString) else { return }
            guard let alpha = alpha else { return }
            
            KingfisherManager.shared.retrieveImage(with: watermarkURL) { result in
                switch result {
                case .success(let value):
                    if let downloadedFrame = value.image.cgImage {
                        let size = CGSize(width: downloadedFrame.width, height: downloadedFrame.height)
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
                        
                        let watermarkImage = UIImage(cgImage: downloadedFrame)
                    
                        let watermarkImageHeight = size.height / 4
                        let watermarkImageWidth = size.width / 4
                        let watermarkImageYPosition = size.height - watermarkImageHeight - (watermarkImageHeight * 0.10)
                        let watermarkImageHorizontalPadding = watermarkImageWidth * 0.10
                        let watermarkImageLeftX = watermarkImageHorizontalPadding
                        let watermarkImageRightX = size.width - watermarkImageWidth - (watermarkImageHorizontalPadding)
                        
                        switch position {
                        case .bottomLeft:
                            watermarkImage.draw(in: CGRect(x: watermarkImageLeftX, y: watermarkImageYPosition, width: watermarkImageWidth, height: watermarkImageHeight), blendMode: .normal, alpha: alpha)

                        case .bottomRight:
                            watermarkImage.draw(in: CGRect(x: watermarkImageRightX, y: watermarkImageYPosition, width: watermarkImageWidth, height: watermarkImageHeight), blendMode: .normal, alpha: alpha)

                        case nil:
                            watermarkImage.draw(in: CGRect(x: watermarkImageLeftX, y: watermarkImageYPosition, width: watermarkImageWidth, height: watermarkImageHeight), blendMode: .normal, alpha: alpha)

                        }
                        
                                                
                        
                        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                            self.processedPhoto = newImage
                            withAnimation {
                                self.photoReady = true
                            }
                        } else {
                            self.processedPhoto = saveImage
                            withAnimation {
                                self.photoReady = true
                            }
                        }
                        
                    }
                case .failure:
                    print("Download Frame Failed")
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
            EventViewModel.shared.refreshEvents()
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

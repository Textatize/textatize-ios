//
//  CameraManager.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/14/23.
//

import AVFoundation
import SwiftUI
import Kingfisher

class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    static let shared = CameraManager()
    
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    @Published var picData: Data?
    @Published var isTaken = false
    @Published var photoReady = false
    @Published var processedPhoto: UIImage?
    @Published var sessionRunning = false
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
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
            DispatchQueue.main.async  {
                self.session.stopRunning()
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

    func processPhotos(frame: Frame?) {
        
        guard let frame = frame else { return  }
        guard let pictureData = self.picData else { return  }
        guard let saveImage = UIImage(data: pictureData) else { return }
        guard let frameURL = URL(string: frame.unwrappedURL) else { return }
        
        KingfisherManager.shared.retrieveImage(with: frameURL) { result in
            switch result {
            case .success(let value):
                if let downloadedFrame = value.image.cgImage {
                    let size = CGSize(width: downloadedFrame.width, height: downloadedFrame.height)
                    UIGraphicsBeginImageContext(size)

                    
                    if let resizeImage = saveImage.resizeImage(size: size) {
                        resizeImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
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
                    print(error)
                }
                
                if let success = success, success {
                    self.alertTitle = "Alert"
                    self.alertMessage = "Media Shared: \(number)"
                    withAnimation {
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
}

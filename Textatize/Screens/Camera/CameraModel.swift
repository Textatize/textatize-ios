//
//  CameraModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/11/23.
//

import AVFoundation
import SwiftUI
import Kingfisher

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData: Data?
    @Published var processedPhoto: UIImage?
    @Published var photoReady = false
        
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setup()
            return
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] status in
                if status {
                    self.setup()
                    return
                }
            }
            
        case .denied:
            self.alert.toggle()
            return
            
        default:
            break
        }
    }
    
    private func setup() {
        
        do {
            
            self.session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else { return }
            
            let input = try AVCaptureDeviceInput(device: device)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        } catch {
            print("Setup Error: \(error.localizedDescription)")
        }
        
    }
    
    func takePic(){
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
            
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                }
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
                withAnimation {
                    self.isTaken.toggle()
                }
            }
        }
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
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let error = error {
//            print("Photo Process Error: \(error.localizedDescription)")
//            return
//        }
        
        print("Pic Taken...")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.picData = imageData
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
}

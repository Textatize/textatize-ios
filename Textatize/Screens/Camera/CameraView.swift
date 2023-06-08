//
//  CameraView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/31/23.
//

import SwiftUI
import Combine
import Kingfisher


struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    var event: Event? = nil
    var frame: Frame?
    @StateObject private var camera = CameraModel()
    @State private var continuePressed = false
    @State private var countDown = 5
    @State private var isActive = false
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()
           
//            ZStack {
//                VStack {
//                    Spacer()
//                    Circle()
//                        .frame(width: 50, height: 50)
//                    Image(uiImage: camera.processPhotos(frame: frame)!)
//                        .resizable()
//                        .frame(width: 100, height: 100)
//                    Spacer()
//                }
//                
//
//            }
            
            if camera.isTaken {
                
                ZStack {
                    
                    Color.black.opacity(camera.photoReady ? 0.95 : 0)
                        .ignoresSafeArea()
                    
                    Image(uiImage: camera.processedPhoto ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        //.frame(width: 200, height: 200)
                
                    VStack {
                        
                        Spacer()
                        HStack {
                            Button {
                                withAnimation {
                                    continuePressed = true
                                }
                            } label: {
                                Text("Continue")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                            .padding(.leading)
                            .padding()
                            
                            Spacer()
                            
                            Button {
                                print("Retake Button Pressed")
                                camera.reTake()
                                restartTimer()
                            } label: {
                                Text("Retake")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                            .padding(.trailing)
                            .padding()
                        }
                    }
                }
                .opacity(camera.photoReady ? 1 : 0)
            } else {
                Circle()
                    .strokeBorder(.red, lineWidth: 5)
                    .frame(width: UIScreen.main.bounds.width * 0.27, height: UIScreen.main.bounds.width * 0.27)
                Text("\(countDown)")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.red)
                
//                VStack {
//                    Spacer()
//
//                    Button {
//                        print("Camera icon pressed")
//                        camera.takePic()
//                        cancelTimer()
//                    } label: {
//                        ZStack {
//                            Circle()
//                                .fill(Color.red)
//                                .frame(width: UIScreen.main.bounds.width * 0.23, height:  UIScreen.main.bounds.width * 0.23)
//                            Image(systemName: "camera.fill")
//                                .resizable()
//                                .frame(width: 45, height: 35)
//                                .foregroundColor(.white)
//                        }
//                    }
//
//                }
            }
            
            if continuePressed {
                ZStack {
                    Color.black.opacity(0.75)
                        .ignoresSafeArea()

                    
                    SharePhotoView(action: dismiss, eventID: event?.unique_id ?? "NO ID", showView: $continuePressed, imageData: camera.retrieveImage()!, image: camera.processedPhoto)
                        .padding()
                }
            
            }
        }
        .onReceive(timer, perform: { time in
            if countDown > 0 {
                countDown -= 1
            } else {
                print("Countdown hit zero, pic taken")
                camera.takePic()
                cancelTimer()
            }
        })
        .onAppear {
            camera.check()
            instantiateTimer()
        }
        .onChange(of: camera.picData, perform: { value in
            let _ = camera.processPhotos(frame: frame)
        })
        .onDisappear {
            cancelTimer()
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func instantiateTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
        return
    }
    
    private func cancelTimer() {
        self.connectedTimer?.cancel()
        return
    }
    
    private func resetCounter() {
        self.countDown = 5
        return
    }
    
    private func restartTimer() {
        self.countDown = 5
        self.cancelTimer()
        self.instantiateTimer()
        return
    }
}

import AVFoundation

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
                        //return newImage
                    } else {
                        self.processedPhoto = saveImage
                        withAnimation {
                            self.photoReady = true
                        }
                        //return saveImage
                    }
                    
                }
            case .failure:
                print("Download Frame Failed")
            }
        }
        
//        if let cacheImage = ImageCache.default.retrieveImageInMemoryCache(forKey: frame.unwrappedURL)?.cgImage {
//            let size = CGSize(width: cacheImage.width, height: cacheImage.height)
//            UIGraphicsBeginImageContext(size)
//
//            
//            if let resizeImage = saveImage.resizeImage(size: size) {
//                resizeImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            }
//            
//            let frameImage = UIImage(cgImage: cacheImage)
//            frameImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            
//            
//            if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
//                self.processedPhoto = newImage
//                withAnimation {
//                    self.photoReady = true
//                }
//                //return newImage
//            } else {
//                self.processedPhoto = saveImage
//                withAnimation {
//                    self.photoReady = true
//                }
//                //return saveImage
//            }
//            
//        }
        
       // return nil
        

      
        
       /// let image = KFImage.url(URL(string: (frame?.unwrappedURL)))
//        let size = CGSize(width: image.siz, height: T##CGFloat)
//
//           for template in selected_templates {
//               if let downloaded_image = template.downloaded_image {
//                   print("TEMPLATE -->\(template.image_url)")
//                   print("TEMPLATE IMAGE -->\(downloaded_image)")
//                   print("TEMPLATE size -->\(downloaded_image.size)")
//                   
//                  // var bottomImage = UIImage(named: "bottom.png")
//                  // var topImage = UIImage(named: "top.png")
//                   
//                   let size = CGSize(width: downloaded_image.size.width, height: downloaded_image.size.height)
//                   UIGraphicsBeginImageContext(size)
//                   
//                                   
//                   var index = 0
//                   for info in template.info {
//                       if let width = info.width, let height = info.height, let top = info.top, let left = info.left {
//                           //print("TEMPLATE size -->\(template.downloaded_image?.size)")
//                           
//                           if let image = taken_photos[index].resizeImage(size: CGSize(width: width, height: height)) {
//                               var tempimage = image
//                               if (flip) {
//                                   print("FLIPPED")
//                                   tempimage = image.rotate(radians: .pi)! // Rotate 90 degrees
//                               }
//                               tempimage.draw(in: CGRect(x: left, y: top, width: width, height: height))
//                           }
//                       }
//                       index += 1
//                   }
//                   
//                   downloaded_image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//                   
//                   
////                   if RevoSpinLoginManager.shared.isFreeUser() {
////                       loggly(LogType.Debug, text: "Applying watermark")
////                       if let image = UIImage(named: "amazeboothwatermark") {
////                           print("OVERLAY IMAGE w=\(abs(image.size.width)) h=\(abs(image.size.height))")
////                           let overlayImage = ImageScaler.imageWithImage(sourceImage: image, scaledToWidth: size.width/3)
////                           print("RESIZED OVERLAY IMAGE w=\(abs(overlayImage.size.width)) h=\(abs(overlayImage.size.height))")
////                           overlayImage.draw(in: CGRect(x: 10, y: size.height-overlayImage.size.height-5, width: overlayImage.size.width, height: overlayImage.size.height))
////                       }
////                   }
//                   if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
//                       finished_photos.append(newImage)
//                   }
//                   UIGraphicsEndImageContext()
//               }
//           }
//           //self.hideHud()
//           
//           //self.chooseFinalImage()
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

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}

//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView()
//    }
//}


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

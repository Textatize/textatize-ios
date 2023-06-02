//
//  CameraView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/31/23.
//

import SwiftUI
import Combine

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
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
           
            if camera.isTaken {
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
            
                    ImageDetailView(showView: $continuePressed, image: camera.retrieveImage())
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
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let error = error {
//            print("Photo Process Error: \(error.localizedDescription)")
//            return
//        }
        
        print("Pic Taken...")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        self.picData = imageData
    }
    
    func retrieveImage() -> Image? {
        
        guard let pictureData = self.picData else { return nil }
        
        guard let saveImage = UIImage(data: pictureData) else { return nil }
        let finalImage = Image(uiImage: saveImage)
        
        print("Image Retrieve")
        return finalImage
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

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

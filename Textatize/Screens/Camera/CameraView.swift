//
//  CameraView.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/31/23.
//

import SwiftUI
import Combine
import Kingfisher
import AVFoundation

struct CameraView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var camera = CameraManager.shared
    @Binding var path: [Int]
    var event: Event? = nil
    var frame: Frame? = nil
    @State private var continuePressed = false
    @State private var countDown = 5
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    @State private var shareMedia = false
    
    var body: some View {
        ZStack {
            HostedViewController(captureSesion: camera.session, deviceOrientation: event?.getOrientation == .landscape ? .landscape : .portrait)
                .ignoresSafeArea()
            
            if camera.isTaken {
                ZStack {
                    
                    Color.black.opacity(camera.photoReady ? 0.95 : 0)
                        .ignoresSafeArea()
                    
                    Image(uiImage: camera.processedPhoto ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                    VStack {
                        
                        Spacer()
                        HStack {
                            Button {
                                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                                withAnimation {
                                    continuePressed = true
                                }
                            } label: {
                                Text("Continue")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
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
                                    .padding(.horizontal, 10)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
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
            }
            
            if continuePressed {
                ZStack {
                    Color.black.opacity(0.75)
                        .ignoresSafeArea()
                    
                    SharePhotoView(eventID: event?.unique_id ?? "NO ID", dismissAction: dismiss, imageData: camera.retrieveImage()!, image: camera.processedPhoto, shareMedia: $shareMedia)
                        .padding()
                }
                
            }
            
            CameraBackButton(path: $path)
                .foregroundColor(AppColors.Onboarding.loginButton)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                .padding(.top)
            
        }
        .alert(camera.alertTitle, isPresented: $camera.showAlert, actions: {
            Button(role: .cancel) {
                camera.isTaken = false
                cancelTimer()
                camera.session.stopRunning()
                dismiss()
            } label: {
                Text("Dissmiss")
            }
        }, message: {
            Text(camera.alertMessage)
        })
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
            camera.event = event
            switch event?.getOrientation {
            case .portrait:
                break
            case .landscape:
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            case .square:
                break
            case nil:
                break
            }
            
            switch event?.getCamera {
            case .front:
                camera.check(orientation: .front)
            case .back:
                camera.check(orientation: .back)
            case nil:
                dismiss()
            }
        }
        .onChange(of: camera.sessionRunning, perform: { value in
            if camera.sessionRunning {
                instantiateTimer()
            }
        })
        .onChange(of: camera.picData, perform: { value in
            let _ = camera.processPhotos(frame: frame)
        })
        .onChange(of: continuePressed, perform: { value in
            if continuePressed {
                if let eventID = event?.unique_id, let imageData = camera.retrieveImage() {
                    camera.addMedia(eventID: eventID, imageData: imageData)
                }
            }
        })
        .onChange(of: shareMedia, perform: { value in
            if shareMedia {
                sharePhoto()
                shareMedia = false
            }
        })
        .onDisappear {
            camera.sessionRunning = false
            camera.isTaken = false
            cancelTimer()
            camera.session.stopRunning()
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
        
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
    
    private func sharePhoto() {
        camera.shareMedia()
    }
    
}

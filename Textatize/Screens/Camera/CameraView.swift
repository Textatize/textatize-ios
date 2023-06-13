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
    var event: Event? = nil
    var frame: Frame?
    @StateObject private var camera = CameraModel()
    @State private var continuePressed = false
    @State private var countDown = 5
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
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
            }
            
            if continuePressed {
                ZStack {
                    Color.black.opacity(0.75)
                        .ignoresSafeArea()

                    
                    SharePhotoView(eventID: event?.unique_id ?? "NO ID", showView: $continuePressed, imageData: camera.retrieveImage()!, image: camera.processedPhoto)
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

//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView()
//    }
//}

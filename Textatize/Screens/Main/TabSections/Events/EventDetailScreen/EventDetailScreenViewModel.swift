//
//  EventDetailScreenViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/7/23.
//

import SwiftUI
import Kingfisher

class EventDetailScreenViewModel: ObservableObject {
    static let shared = EventDetailScreenViewModel()
    
    @Published var medias = [Media]()
    @Published var frames = [Frame]()
    @Published var selectedMedia: Media? = nil
    @Published var selectedMediaImage: UIImage? = nil
    @Published var selectedMediaImageData: Data? = nil
    @Published var showGalleryImage = false
    
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    @Published var mediaShared = false
    
    let textatizeAPI = TextatizeAPI.shared

    
    private init() { }
    
    func getMedia(event: Event) {
        if let eventId = event.unique_id {
            textatizeAPI.retrieveMedia(page: nil, eventID: eventId) { [weak self] error, mediaResponse in
                guard let self = `self` else { return }
                
                if let error = error {
                    print(error.getMessage() ?? "No Message Found")
                }
                
                if let mediaResponse = mediaResponse, let APIMedias = mediaResponse.medias {
                    self.medias = APIMedias
                    print("Media For \(eventId)")
                    print(medias.count)
                }
            }
        }
        
    }
    
    func getFrames(orientation: Orientation?, page: String?) {
        textatizeAPI.retrieveFrames(orientation: orientation) { [weak self] error, framesResponse in
            guard let self = `self` else { return }
            
            if let error = error {
                print(error.getMessage() ?? "No Message Found")
            }
            
            if let framesResponse = framesResponse, let APIFrames = framesResponse.frames {
                self.frames = APIFrames
                print("Frames Success")
                print(frames.count)
            }
        }
    }
    
    func getFrameImage(frame: Frame? = nil) -> Image? {
        
        if let frame = frame {
            guard let frameID = frame.unique_id else {
                return Image(systemName: "photo")
            }
            guard let frameImage = ImageCache.default.retrieveImageInMemoryCache(forKey: frameID) else {
                return Image(systemName: "photo")
            }
            return Image(uiImage: frameImage)
        }
        return nil
    }
    
    func getImageData(media: Media) {
        self.selectedMedia = media
        guard let mediaURL = URL(string: media.unwrappedURL) else { return }
        KingfisherManager.shared.retrieveImage(with: mediaURL) { result in
            switch result {
            case .success(let value):
                if let cgImage = value.image.cgImage {
                    self.selectedMediaImage = UIImage(cgImage: cgImage)
                    if let imageData = self.selectedMediaImage?.jpegData(compressionQuality: 0.5) {
                        self.selectedMediaImageData = imageData
                        print("Media Image Retrieved Successful")
                        withAnimation {
                            self.showGalleryImage = true
                        }
                    }
                }
            case .failure(_):
                print("Media Image Not retrieved")
            }
        }
    }
    
    func shareMedia(number: String, mediaID: String) {
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

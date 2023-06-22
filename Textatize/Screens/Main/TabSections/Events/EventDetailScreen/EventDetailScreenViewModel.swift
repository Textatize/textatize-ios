//
//  EventDetailScreenViewModel.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/7/23.
//

import SwiftUI
import Kingfisher
import Combine

class EventDetailScreenViewModel: ObservableObject {
    static let shared = EventDetailScreenViewModel()
    
    @Published var medias = [Media]()
    @Published var frames = [Frame]()
    @Published var selectedMediaImage: UIImage? = nil
    @Published var selectedMediaImageData: Data? = nil
    @Published var showGallaryImage = false
    
    @Published var eventFrame: UIImage? = nil
    @Published var eventWatermark: UIImage? = nil
    @Published var eventMediaImages = [UIImage]()
    
    let textatizeAPI = TextatizeAPI.shared
    let sessionQue = DispatchQueue(label: "DownloadSession")
    
    private init() { }
    
    func reset() {
        medias = []
        frames = []
        eventFrame = nil
        eventWatermark = nil
        eventMediaImages = []
    }
    
    func downloadFrame(event: Event) {
        guard let frame = event.frame else { return }
        guard let frameURL = URL(string: frame.unwrappedURL) else { return }
        FileDownloader.shared.loadFileAsync(url: frameURL) { [weak self] path, error in
            guard let self = `self` else { return }

            if let error = error {
                print("Frame Download Error: \(error)")
            }
            if let path = path {
                if let frameImage = UIImage(named: path) {
                    DispatchQueue.main.async {
                        self.eventFrame = frameImage
                    }
                }
            }
        }
    }
    
    func downloadWatermark(event: Event) {
        guard let watermarkURL = URL(string: event.getWatermarkUrl) else { return }
        FileDownloader.shared.loadFileAsync(url: watermarkURL) { [weak self] path, error in
            guard let self = `self` else { return }
            
            if let error = error {
                print("Watermark Download Error: \(error)")
            }
            if let path = path {
                if let watermarkImage = UIImage(named: path) {
                    DispatchQueue.main.async {
                        self.eventWatermark = watermarkImage
                    }
                }
            }
        }
    }
    
    private func downloadMedia(medias: [Media]) {
        for media in medias {
            guard let mediaURL = URL(string: media.unwrappedURL) else { return }
            FileDownloader.shared.loadFileAsync(url: mediaURL) { [weak self] path, error in
                guard let self = `self` else { return }
                if let error = error {
                    print("Frame Download Error: \(error)")
                }
                if let path = path {
                    if let mediaImage = UIImage(named: path) {
                        DispatchQueue.main.async {
                            self.eventMediaImages.append(mediaImage)
                        }
                    }
                }
            }
        }
    }
    
    
    func getMedia(event: Event) {
        if let eventId = event.unique_id {
            textatizeAPI.retrieveMedia(page: nil, eventID: eventId) { [weak self] error, mediaResponse in
                guard let self = `self` else { return }
                
                if let error = error {
                    print(error.getMessage() ?? "No Message Found")
                }
                
                if let mediaResponse = mediaResponse, let APIMedias = mediaResponse.medias {
                    downloadMedia(medias: APIMedias)
                }
            }
        }
        
    }
    
    func getImageData(mediaImage: UIImage) {
        self.selectedMediaImage = mediaImage
        if let imageData = mediaImage.jpegData(compressionQuality: 0.5) {
            self.selectedMediaImageData = imageData
            withAnimation {
                self.showGallaryImage = true
            }
        }
    }
}

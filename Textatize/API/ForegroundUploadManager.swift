//
//  ForegroundUploadManager.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/5/23.
//

import Foundation
import ObjectBox
import UIKit

public class ForegroundUploadManager: NSObject {
    
    static let shared: ForegroundUploadManager = ForegroundUploadManager()
    let imageBox = Services.instance.imageBox
    var uploading: Bool = false
    var timer: Timer?
    static let videoAddedNotification = "VideoAddedNotification"
    var queue: DispatchQueue = DispatchQueue.global(qos: .default)
    
    var work_item: DispatchWorkItem?
    let group = DispatchGroup()
    
    override init() {
        super.init()
//        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: ForegroundUploadManager.videoAddedNotification),
//                                               object: nil, queue: nil,
//                                               using: catchVideoNotification)
    }

    func catchVideoNotification(notification: Notification) {
        // check every minute
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.checkUploads), userInfo: nil, repeats: true)
    }

    @objc func checkUploads() {
        if self.uploading {
            return
        }
        
        do {
            let query: Query<LocalImage> = try imageBox.query() {
                (LocalImage.markForUpload.isEqual(to: 1) || LocalImage.markForUpload.isEqual(to: 0)) &&
                LocalImage.uploaded.isEqual(to: false)
            }.build()
            print("#### 1 TOTAL TO UPLOAD -->\(try query.count())")
            if try query.count() > 0 {
                
                if !self.uploading {
                    self.upload()
                }
                
            } else {
                // check again later
                if let timer = self.timer {
                    timer.invalidate()
                    self.timer = nil
                }
                self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.checkUploads), userInfo: nil, repeats: true)
            }
        } catch let error {
            print("Query Error:\(error)")
            // check again later
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
            self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.checkUploads), userInfo: nil, repeats: true)
        }
        
    }
    
    func restartUploads(unique_id:String?) {
        do {
            var query: Query<LocalImage>? = nil
            if let unique_id = unique_id {
                query = try imageBox.query() {
                    LocalImage.unique_id == unique_id &&
                    LocalImage.markForUpload.isEqual(to: 2)
                }.build()
            } else {
                query = try imageBox.query() {
                    LocalImage.markForUpload.isEqual(to: 2)
                }.build()
            }
            if let query = query {
                for localImage in try query.find() {
                    localImage.markForUpload = 1
                    do {
                        try imageBox.put(localImage)
                    } catch let error {
                        print("Could not update video. Error:\(error)")
                    }
                }
                ForegroundUploadManager.shared.checkUploads()
            }
        } catch let error {
            print("Could not query. Error:\(error)")
        }
    }

    func markForUpload(localImage:LocalImage) {
        localImage.markForUpload = 1
        do {
            try imageBox.put(localImage)
        } catch let error {
            print("Could not update video. Error:\(error)")
        }
        DispatchQueue.global().async {
            ForegroundUploadManager.shared.checkUploads()
        }
    }
    

    func handleNextVideo() {
        do {
            let query: Query<LocalImage> = try imageBox.query() {
                (LocalImage.markForUpload.isEqual(to: 1) || LocalImage.markForUpload.isEqual(to: 0)) &&
                LocalImage.uploaded.isEqual(to: false)
            }.build()
            print("#### 2 TOTAL TO UPLOAD -->\(try query.count())")
            if try query.count() > 0 {
                let filemgr = FileManager.default
                let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
                let docsDir = dirPaths.first!
                
                if let localImage = try query.findFirst() {
                    localImage.markForUpload = 2 // prevent from starting again
                    do {
                        try imageBox.put(localImage)
                    } catch let error {
                        print("Could not update video. Error:\(error)")
                    }
                    
                    //let imagePath = docsDir.appendingPathComponent(localImage.url!)
                }
            } else {
                // done
                print("@@@@ GROUP LEAVE")
                self.group.leave()
            }
        } catch let error {
            print("Query Error:\(error)")
            // check again later
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
            self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.checkUploads), userInfo: nil, repeats: true)
        }
    }
    
    func upload() {
        self.work_item = DispatchWorkItem {
            self.handleNextVideo()
        }

        print("@@@@ GROUP ENTER")
        self.group.enter()
        if let work_item = self.work_item {
            self.queue.async(execute: work_item)
        }
        self.group.notify(queue: .main) {
            print("UPLOAD COMPLETED.")
            self.uploading = false
            self.didComplete()
        }
    }
    
    func didComplete() {
        if let work_item = self.work_item {
            work_item.cancel()
            self.work_item = nil
        }
    }
    
}

extension NSNotification.Name {
    static let videosChanged = Notification.Name("videosChanged")
}

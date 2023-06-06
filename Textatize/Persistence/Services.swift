//
//  Services.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/5/23.
//

import ObjectBox
import Foundation

class Services {
    static let instance: Services = Services()
    
    let store: Store!
    let imageBox: Box<LocalImage>

    private init() {
        self.store = try! Store.createStore()

        imageBox = self.store.box(for: LocalImage.self)
    }

    func clearDB() throws {
        try imageBox.removeAll()
    }
    
    /*
    func replaceWithDemoData() throws {
        try noteBox.removeAll()
        try authorBox.removeAll()

        let peterBrett = Author(name: "Peter V. Brett")
        let georgeMartin = Author(name: "George R. R. Martin")
        try authorBox.put([peterBrett, georgeMartin])

        try noteBox.put([
            Note(title: "Unclaimed idea", text: "This writing is not by anyone in particular."),
            peterBrett.writeNote(title: "The Warded Man", text: "I should make a movie from this book after writing the next novel."),
            peterBrett.writeNote(title: "Daylight War", text: "Who picked the cover art for this? It certainly wasn't me or someone else with taste."),
            georgeMartin.writeNote(title: "Game of Thrones", text: "This book title would've been a better choice than this Ice & Fire stuff all along. Boy, writing this takes long in DOS.")
            ])
    }*/
}

extension Store {
    /// Creates a new ObjectBox.Store in a temporary directory.
    static func createStore() throws -> Store {
        let directory = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true).appendingPathComponent(Bundle.main.bundleIdentifier!)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: false, attributes: nil)
        return try Store(directoryPath: directory.path)
    }
}

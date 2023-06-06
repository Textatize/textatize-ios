// Generated using the ObjectBox Swift Generator — https://objectbox.io
// DO NOT EDIT

// swiftlint:disable all
import ObjectBox
import Foundation

// MARK: - Entity metadata


extension LocalImage: ObjectBox.__EntityRelatable {
    internal typealias EntityType = LocalImage

    internal var _id: EntityId<LocalImage> {
        return EntityId<LocalImage>(self.id.value)
    }
}

extension LocalImage: ObjectBox.EntityInspectable {
    internal typealias EntityBindingType = LocalImageBinding

    /// Generated metadata used by ObjectBox to persist the entity.
    internal static var entityInfo = ObjectBox.EntityInfo(name: "LocalImage", id: 1)

    internal static var entityBinding = EntityBindingType()

    fileprivate static func buildEntity(modelBuilder: ObjectBox.ModelBuilder) throws {
        let entityBuilder = try modelBuilder.entityBuilder(for: LocalImage.self, id: 1, uid: 4562880120354276096)
        try entityBuilder.addProperty(name: "id", type: PropertyType.long, flags: [.id], id: 1, uid: 1820365422616872448)
        try entityBuilder.addProperty(name: "eventID", type: PropertyType.string, id: 13, uid: 3941454058412486144)
        try entityBuilder.addProperty(name: "imageData", type: PropertyType.byteVector, id: 14, uid: 1065617415738381056)
        try entityBuilder.addProperty(name: "unique_id", type: PropertyType.string, id: 15, uid: 1342327412439296768)
        try entityBuilder.addProperty(name: "created_time", type: PropertyType.long, id: 9, uid: 5521516947477985536)
        try entityBuilder.addProperty(name: "updated_time", type: PropertyType.long, id: 10, uid: 8549413436284027648)
        try entityBuilder.addProperty(name: "created_formatted", type: PropertyType.string, id: 11, uid: 5535936087993491200)
        try entityBuilder.addProperty(name: "uploaded", type: PropertyType.bool, id: 3, uid: 1967326508009963008)
        try entityBuilder.addProperty(name: "markForUpload", type: PropertyType.long, id: 4, uid: 1610164990942574848)

        try entityBuilder.lastProperty(id: 15, uid: 1342327412439296768)
    }
}

extension LocalImage {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { LocalImage.id == myId }
    internal static var id: Property<LocalImage, Id, Id> { return Property<LocalImage, Id, Id>(propertyId: 1, isPrimaryKey: true) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { LocalImage.eventID.startsWith("X") }
    internal static var eventID: Property<LocalImage, String?, Void> { return Property<LocalImage, String?, Void>(propertyId: 13, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { LocalImage.imageData > 1234 }
    internal static var imageData: Property<LocalImage, Data?, Void> { return Property<LocalImage, Data?, Void>(propertyId: 14, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { LocalImage.unique_id.startsWith("X") }
    internal static var unique_id: Property<LocalImage, String, Void> { return Property<LocalImage, String, Void>(propertyId: 15, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { LocalImage.created_time > 1234 }
    internal static var created_time: Property<LocalImage, Int?, Void> { return Property<LocalImage, Int?, Void>(propertyId: 9, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { LocalImage.updated_time > 1234 }
    internal static var updated_time: Property<LocalImage, Int?, Void> { return Property<LocalImage, Int?, Void>(propertyId: 10, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { LocalImage.created_formatted.startsWith("X") }
    internal static var created_formatted: Property<LocalImage, String?, Void> { return Property<LocalImage, String?, Void>(propertyId: 11, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { LocalImage.uploaded == true }
    internal static var uploaded: Property<LocalImage, Bool, Void> { return Property<LocalImage, Bool, Void>(propertyId: 3, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { LocalImage.markForUpload > 1234 }
    internal static var markForUpload: Property<LocalImage, Int, Void> { return Property<LocalImage, Int, Void>(propertyId: 4, isPrimaryKey: false) }

    fileprivate func __setId(identifier: ObjectBox.Id) {
        self.id = Id(identifier)
    }
}

extension ObjectBox.Property where E == LocalImage {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .id == myId }

    internal static var id: Property<LocalImage, Id, Id> { return Property<LocalImage, Id, Id>(propertyId: 1, isPrimaryKey: true) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .eventID.startsWith("X") }

    internal static var eventID: Property<LocalImage, String?, Void> { return Property<LocalImage, String?, Void>(propertyId: 13, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .imageData > 1234 }

    internal static var imageData: Property<LocalImage, Data?, Void> { return Property<LocalImage, Data?, Void>(propertyId: 14, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .unique_id.startsWith("X") }

    internal static var unique_id: Property<LocalImage, String, Void> { return Property<LocalImage, String, Void>(propertyId: 15, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .created_time > 1234 }

    internal static var created_time: Property<LocalImage, Int?, Void> { return Property<LocalImage, Int?, Void>(propertyId: 9, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .updated_time > 1234 }

    internal static var updated_time: Property<LocalImage, Int?, Void> { return Property<LocalImage, Int?, Void>(propertyId: 10, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .created_formatted.startsWith("X") }

    internal static var created_formatted: Property<LocalImage, String?, Void> { return Property<LocalImage, String?, Void>(propertyId: 11, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .uploaded == true }

    internal static var uploaded: Property<LocalImage, Bool, Void> { return Property<LocalImage, Bool, Void>(propertyId: 3, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .markForUpload > 1234 }

    internal static var markForUpload: Property<LocalImage, Int, Void> { return Property<LocalImage, Int, Void>(propertyId: 4, isPrimaryKey: false) }

}


/// Generated service type to handle persisting and reading entity data. Exposed through `LocalImage.EntityBindingType`.
internal class LocalImageBinding: ObjectBox.EntityBinding {
    internal typealias EntityType = LocalImage
    internal typealias IdType = Id

    internal required init() {}

    internal func generatorBindingVersion() -> Int { 1 }

    internal func setEntityIdUnlessStruct(of entity: EntityType, to entityId: ObjectBox.Id) {
        entity.__setId(identifier: entityId)
    }

    internal func entityId(of entity: EntityType) -> ObjectBox.Id {
        return entity.id.value
    }

    internal func collect(fromEntity entity: EntityType, id: ObjectBox.Id,
                                  propertyCollector: ObjectBox.FlatBufferBuilder, store: ObjectBox.Store) throws {
        let propertyOffset_eventID = propertyCollector.prepare(string: entity.eventID)
        let propertyOffset_imageData = propertyCollector.prepare(bytes: entity.imageData)
        let propertyOffset_unique_id = propertyCollector.prepare(string: entity.unique_id)
        let propertyOffset_created_formatted = propertyCollector.prepare(string: entity.created_formatted)

        propertyCollector.collect(id, at: 2 + 2 * 1)
        propertyCollector.collect(entity.created_time, at: 2 + 2 * 9)
        propertyCollector.collect(entity.updated_time, at: 2 + 2 * 10)
        propertyCollector.collect(entity.uploaded, at: 2 + 2 * 3)
        propertyCollector.collect(entity.markForUpload, at: 2 + 2 * 4)
        propertyCollector.collect(dataOffset: propertyOffset_eventID, at: 2 + 2 * 13)
        propertyCollector.collect(dataOffset: propertyOffset_imageData, at: 2 + 2 * 14)
        propertyCollector.collect(dataOffset: propertyOffset_unique_id, at: 2 + 2 * 15)
        propertyCollector.collect(dataOffset: propertyOffset_created_formatted, at: 2 + 2 * 11)
    }

    internal func createEntity(entityReader: ObjectBox.FlatBufferReader, store: ObjectBox.Store) -> EntityType {
        let entity = LocalImage()

        entity.id = entityReader.read(at: 2 + 2 * 1)
        entity.eventID = entityReader.read(at: 2 + 2 * 13)
        entity.imageData = entityReader.read(at: 2 + 2 * 14)
        entity.unique_id = entityReader.read(at: 2 + 2 * 15)
        entity.created_time = entityReader.read(at: 2 + 2 * 9)
        entity.updated_time = entityReader.read(at: 2 + 2 * 10)
        entity.created_formatted = entityReader.read(at: 2 + 2 * 11)
        entity.uploaded = entityReader.read(at: 2 + 2 * 3)
        entity.markForUpload = entityReader.read(at: 2 + 2 * 4)

        return entity
    }
}


/// Helper function that allows calling Enum(rawValue: value) with a nil value, which will return nil.
fileprivate func optConstruct<T: RawRepresentable>(_ type: T.Type, rawValue: T.RawValue?) -> T? {
    guard let rawValue = rawValue else { return nil }
    return T(rawValue: rawValue)
}

// MARK: - Store setup

fileprivate func cModel() throws -> OpaquePointer {
    let modelBuilder = try ObjectBox.ModelBuilder()
    try LocalImage.buildEntity(modelBuilder: modelBuilder)
    modelBuilder.lastEntity(id: 1, uid: 4562880120354276096)
    return modelBuilder.finish()
}

extension ObjectBox.Store {
    /// A store with a fully configured model. Created by the code generator with your model's metadata in place.
    ///
    /// - Parameters:
    ///   - directoryPath: The directory path in which ObjectBox places its database files for this store.
    ///   - maxDbSizeInKByte: Limit of on-disk space for the database files. Default is `1024 * 1024` (1 GiB).
    ///   - fileMode: UNIX-style bit mask used for the database files; default is `0o644`.
    ///     Note: directories become searchable if the "read" or "write" permission is set (e.g. 0640 becomes 0750).
    ///   - maxReaders: The maximum number of readers.
    ///     "Readers" are a finite resource for which we need to define a maximum number upfront.
    ///     The default value is enough for most apps and usually you can ignore it completely.
    ///     However, if you get the maxReadersExceeded error, you should verify your
    ///     threading. For each thread, ObjectBox uses multiple readers. Their number (per thread) depends
    ///     on number of types, relations, and usage patterns. Thus, if you are working with many threads
    ///     (e.g. in a server-like scenario), it can make sense to increase the maximum number of readers.
    ///     Note: The internal default is currently around 120.
    ///           So when hitting this limit, try values around 200-500.
    /// - important: This initializer is created by the code generator. If you only see the internal `init(model:...)`
    ///              initializer, trigger code generation by building your project.
    internal convenience init(directoryPath: String, maxDbSizeInKByte: UInt64 = 1024 * 1024,
                            fileMode: UInt32 = 0o644, maxReaders: UInt32 = 0, readOnly: Bool = false) throws {
        try self.init(
            model: try cModel(),
            directory: directoryPath,
            maxDbSizeInKByte: maxDbSizeInKByte,
            fileMode: fileMode,
            maxReaders: maxReaders,
            readOnly: readOnly)
    }
}

// swiftlint:enable all

// GRDB is available only on Apple platforms (Xcode).
// This file provides DatabaseManager using GRDB DatabaseQueue.
// On Linux (CI/preview) this target is not compiled.

#if canImport(GRDB)
import Foundation
import GRDB

/// Manages the SQLite database queue in Application Support.
struct DatabaseManager: Sendable {
  let queue: DatabaseQueue

  static func makeDefault() throws -> DatabaseManager {
    let fileManager = FileManager.default
    let folder = try fileManager.url(
      for: .applicationSupportDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )
    let dbURL = folder.appending(path: "otsrochka.sqlite")
    let queue = try DatabaseQueue(path: dbURL.path)
    var migrator = DatabaseMigrator()
    Migrations.register(&migrator)
    try migrator.migrate(queue)
    return DatabaseManager(queue: queue)
  }

  static func makeInMemory() throws -> DatabaseManager {
    let queue = try DatabaseQueue()
    var migrator = DatabaseMigrator()
    Migrations.register(&migrator)
    try migrator.migrate(queue)
    return DatabaseManager(queue: queue)
  }
}
#else
import Foundation

/// Placeholder for non-Apple platforms so the package graph stays valid.
struct DatabaseManager: Sendable {}
#endif

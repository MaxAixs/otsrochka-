import Foundation

/// Repository protocol for person persistence.
/// Implemented by Data layer (GRDB). Domain knows only this interface.
public protocol PersonRepository: Sendable {
  func save(_ person: Person) async throws
  func fetch() async throws -> Person?
  func delete() async throws
}

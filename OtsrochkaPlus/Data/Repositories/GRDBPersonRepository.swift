import Foundation

#if canImport(GRDB)
import GRDB

/// GRDB implementation of PersonRepository.
struct GRDBPersonRepository: PersonRepository {
  let manager: DatabaseManager

  static func makeDefault() -> GRDBPersonRepository {
    // swiftlint:disable:next force_try
    let manager = try! DatabaseManager.makeDefault()
    return GRDBPersonRepository(manager: manager)
  }

  func save(_ person: Person) async throws {
    try await manager.queue.write { db in
      try db.execute(
        sql: """
          INSERT OR REPLACE INTO person
            (id, firstName, lastName, patronymic, dateOfBirth, createdAt, updatedAt)
          VALUES (?, ?, ?, ?, ?, ?, ?)
          """,
        arguments: [
          person.id,
          person.firstName,
          person.lastName,
          person.patronymic,
          ISO8601DateFormatter().string(from: person.dateOfBirth),
          ISO8601DateFormatter().string(from: person.createdAt),
          ISO8601DateFormatter().string(from: person.updatedAt)
        ]
      )
    }
  }

  func fetch() async throws -> Person? {
    try await manager.queue.read { db in
      guard let row = try Row.fetchOne(db, sql: "SELECT * FROM person ORDER BY id DESC LIMIT 1") else {
        return nil
      }
      return GRDBPersonRepository.person(from: row)
    }
  }

  func delete() async throws {
    try await manager.queue.write { db in
      try db.execute(sql: "DELETE FROM person")
    }
  }

  private static func person(from row: Row) -> Person? {
    guard
      let firstName: String = row["firstName"],
      let lastName: String = row["lastName"],
      let patronymic: String = row["patronymic"],
      let dobString: String = row["dateOfBirth"]
    else {
      return nil
    }
    let formatter = ISO8601DateFormatter()
    guard let dob = formatter.date(from: dobString) else {
      return nil
    }
    return Person(
      id: row["id"],
      firstName: firstName,
      lastName: lastName,
      patronymic: patronymic,
      dateOfBirth: dob
    )
  }
}
#else
/// Placeholder for non-Apple platforms.
struct GRDBPersonRepository: PersonRepository {
  static func makeDefault() -> GRDBPersonRepository {
    GRDBPersonRepository()
  }

  func save(_ person: Person) async throws {}
  func fetch() async throws -> Person? { nil }
  func delete() async throws {}
}
#endif

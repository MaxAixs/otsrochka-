#if canImport(GRDB)
import GRDB

/// Database migrations. Never use ad-hoc CREATE TABLE.
enum Migrations {
  static func register(_ migrator: inout DatabaseMigrator) {
    migrator.registerMigration("v1_create_person") { db in
      try db.create(table: "person") { table in
        table.autoIncrementedPrimaryKey("id")
        table.column("firstName", .text).notNull()
        table.column("lastName", .text).notNull()
        table.column("patronymic", .text).notNull()
        table.column("dateOfBirth", .text).notNull()
        table.column("createdAt", .text).notNull()
        table.column("updatedAt", .text).notNull()
      }
    }
  }
}
#endif

import Foundation

/// Domain entity representing a person stored locally.
/// Demo data only — no real IDs, no sensitive information.
public struct Person: Equatable, Sendable, Codable {
  public let id: Int64?
  public var firstName: String
  public var lastName: String
  public var patronymic: String
  public var dateOfBirth: Date
  public var createdAt: Date
  public var updatedAt: Date

  public init(
    id: Int64? = nil,
    firstName: String,
    lastName: String,
    patronymic: String,
    dateOfBirth: Date,
    createdAt: Date = Date.now,
    updatedAt: Date = Date.now
  ) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.patronymic = patronymic
    self.dateOfBirth = dateOfBirth
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }

  /// Full name in Ukrainian order: lastName firstName patronymic.
  public var fullName: String {
    "\(lastName) \(firstName) \(patronymic)"
  }

  /// QR payload: JSON with public fields only.
  public func qrPayload() throws -> Data {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate]
    let payload: [String: String] = [
      "lastName": lastName,
      "firstName": firstName,
      "patronymic": patronymic,
      "dateOfBirth": formatter.string(from: dateOfBirth)
    ]
    return try JSONSerialization.data(withJSONObject: payload, options: [.sortedKeys])
  }
}

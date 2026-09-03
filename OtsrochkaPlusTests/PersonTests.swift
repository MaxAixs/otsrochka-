import Foundation
import XCTest

@testable import OtsrochkaPlus

/// Round-trip test for QR payload encoding.
final class PersonPayloadTests: XCTestCase {
  func testQrPayloadRoundTrip() throws {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate]
    guard let dob = formatter.date(from: "1990-05-14") else {
      XCTFail("Invalid fixture date")
      return
    }
    let person = Person(
      firstName: "Тарас",
      lastName: "Шевченко",
      patronymic: "Григорович",
      dateOfBirth: dob
    )
    XCTAssertEqual(person.fullName, "Шевченко Тарас Григорович")

    let data = try person.qrPayload()
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: String] else {
      XCTFail("Payload is not a string dictionary")
      return
    }
    XCTAssertEqual(json["firstName"], "Тарас")
    XCTAssertEqual(json["lastName"], "Шевченко")
    XCTAssertEqual(json["dateOfBirth"], "1990-05-14")
  }
}

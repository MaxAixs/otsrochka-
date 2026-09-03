import Foundation

/// Use case for saving a person.
public protocol SavePersonUseCaseProtocol: Sendable {
  func execute(_ person: Person) async throws
}

public struct SavePersonUseCase: SavePersonUseCaseProtocol {
  private let repository: any PersonRepository

  public init(repository: any PersonRepository) {
    self.repository = repository
  }

  public func execute(_ person: Person) async throws {
    guard !person.firstName.isEmpty, !person.lastName.isEmpty else {
      throw PersonValidationError.emptyName
    }
    try await repository.save(person)
  }
}

public enum PersonValidationError: Error, Equatable {
  case emptyName
}

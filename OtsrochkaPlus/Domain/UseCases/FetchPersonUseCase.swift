import Foundation

/// Use case for fetching the stored person (if any).
public protocol FetchPersonUseCaseProtocol: Sendable {
  func execute() async throws -> Person?
}

public struct FetchPersonUseCase: FetchPersonUseCaseProtocol {
  private let repository: any PersonRepository

  public init(repository: any PersonRepository) {
    self.repository = repository
  }

  public func execute() async throws -> Person? {
    try await repository.fetch()
  }
}

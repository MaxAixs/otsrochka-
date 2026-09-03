import Foundation
import Observation

/// ViewModel for the document card (scaffold).
@MainActor
@Observable
public final class DocumentViewModel {
  public var person: Person?
  public var isQRVisible = false

  private let fetchUseCase: any FetchPersonUseCaseProtocol

  public init(fetchUseCase: any FetchPersonUseCaseProtocol) {
    self.fetchUseCase = fetchUseCase
  }

  func load() async {
    person = try? await fetchUseCase.execute()
  }

  func toggleQR() {
    isQRVisible.toggle()
  }
}

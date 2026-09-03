import Foundation
import Observation

/// ViewModel for the registration form (stub for next step).
@MainActor
@Observable
public final class RegistrationViewModel {
  public var firstName = ""
  public var lastName = ""
  public var patronymic = ""
  public var dateOfBirth = Date.now
  public var errorMessage: String?

  private let saveUseCase: any SavePersonUseCaseProtocol
  private let onSaved: () -> Void

  public init(saveUseCase: any SavePersonUseCaseProtocol, onSaved: @escaping () -> Void = {}) {
    self.saveUseCase = saveUseCase
    self.onSaved = onSaved
  }

  func save() async {
    let person = Person(
      firstName: firstName,
      lastName: lastName,
      patronymic: patronymic,
      dateOfBirth: dateOfBirth
    )
    do {
      try await saveUseCase.execute(person)
      onSaved()
    } catch {
      errorMessage = error.localizedDescription
    }
  }
}

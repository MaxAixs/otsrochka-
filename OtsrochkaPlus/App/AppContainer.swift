import Foundation

/// Dependency injection container (the only allowed shared composition root).
@MainActor
@Observable
final class AppContainer {
  let personRepository: any PersonRepository
  let savePersonUseCase: any SavePersonUseCaseProtocol
  let fetchPersonUseCase: any FetchPersonUseCaseProtocol

  init(
    personRepository: any PersonRepository,
    savePersonUseCase: any SavePersonUseCaseProtocol,
    fetchPersonUseCase: any FetchPersonUseCaseProtocol
  ) {
    self.personRepository = personRepository
    self.savePersonUseCase = savePersonUseCase
    self.fetchPersonUseCase = fetchPersonUseCase
  }

  static func makeDefault() -> AppContainer {
    let repository = GRDBPersonRepository.makeDefault()
    return AppContainer(
      personRepository: repository,
      savePersonUseCase: SavePersonUseCase(repository: repository),
      fetchPersonUseCase: FetchPersonUseCase(repository: repository)
    )
  }

  func makeRegistrationViewModel(onSaved: @escaping () -> Void) -> RegistrationViewModel {
    RegistrationViewModel(saveUseCase: savePersonUseCase, onSaved: onSaved)
  }

  func makeDocumentViewModel() -> DocumentViewModel {
    DocumentViewModel(fetchUseCase: fetchPersonUseCase)
  }
}

import SwiftUI

/// Composition root wiring Domain + Data + Presentation.
@MainActor
struct OtsrochkaPlusApp: App {
  @State private var coordinator = AppCoordinator()
  @State private var container = AppContainer.makeDefault()

  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $coordinator.path) {
        StartView(viewModel: StartViewModel {
          coordinator.showRegistration()
        })
        .navigationDestination(for: AppRoute.self) { route in
          switch route {
          case .registration:
            RegistrationView(
              viewModel: container.makeRegistrationViewModel {
                coordinator.showDocument()
              }
            )
          case .document:
            DocumentView(viewModel: container.makeDocumentViewModel())
          }
        }
      }
    }
  }
}

import SwiftUI

/// App navigation flow.
enum AppRoute: Hashable {
  case registration
  case document
}

/// Coordinator owning the NavigationStack path.
/// Views never navigate directly.
@MainActor
@Observable
final class AppCoordinator {
  var path: [AppRoute] = []

  func showRegistration() {
    path.append(.registration)
  }

  func showDocument() {
    path.append(.document)
  }

  func popToRoot() {
    path.removeAll()
  }
}

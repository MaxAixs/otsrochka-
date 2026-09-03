import Foundation
import Observation

/// ViewModel for the Start screen.
/// Holds no state except navigation intent; testable via protocol.
@MainActor
@Observable
public final class StartViewModel {
  public var onStartTapped: (() -> Void)?

  public init(onStartTapped: (() -> Void)? = nil) {
    self.onStartTapped = onStartTapped
  }

  func didTapStart() {
    onStartTapped?()
  }
}

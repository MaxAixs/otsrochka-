import SwiftUI

/// Start screen with a single "Почати" button.
/// Text comes from Localizable.xcstrings via String(localized:).
struct StartView: View {
  var viewModel: StartViewModel

  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      Image(systemName: "shield.checkered")
        .font(.system(size: 64))
        .foregroundStyle(.tint)
        .accessibilityHidden(true)
      Text(String(localized: "start.title", bundle: .main))
        .font(.title)
        .multilineTextAlignment(.center)
      Spacer()
      Button(String(localized: "start.button", bundle: .main)) {
        viewModel.didTapStart()
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .accessibilityIdentifier("startButton")
      .padding(.bottom, 32)
    }
    .padding()
  }
}

#Preview {
  StartView(viewModel: StartViewModel())
}

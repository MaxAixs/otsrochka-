import SwiftUI

/// Registration form (scaffold — full fields in next iteration).
struct RegistrationView: View {
  @Bindable var viewModel: RegistrationViewModel

  var body: some View {
    Form {
      TextField(String(localized: "registration.firstName", bundle: .main), text: $viewModel.firstName)
      TextField(String(localized: "registration.lastName", bundle: .main), text: $viewModel.lastName)
      TextField(String(localized: "registration.patronymic", bundle: .main), text: $viewModel.patronymic)
      DatePicker(
        String(localized: "registration.birthDate", bundle: .main),
        selection: $viewModel.dateOfBirth,
        displayedComponents: .date
      )
      Button(String(localized: "registration.save", bundle: .main)) {
        Task { await viewModel.save() }
      }
      .buttonStyle(.borderedProminent)
    }
    .navigationTitle(String(localized: "registration.title", bundle: .main))
  }
}

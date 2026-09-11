import SwiftUI

/// Electronic document card (scaffold — QR + ribbon in next iteration).
struct DocumentView: View {
  var viewModel: DocumentViewModel

  var body: some View {
    VStack(spacing: 16) {
      UpdatedRibbonView(date: .now)
      if let person = viewModel.person {
        Text(person.fullName)
          .font(.headline)
        Text(
          String(
            format: String(localized: "document.birthDate", bundle: .main),
            person.dateOfBirth.formatted(date: .long, time: .omitted)
          )
        )
        .font(.subheadline)
        Text(
          String(
            format: String(localized: "document.defermentUntil", bundle: .main),
            person.defermentUntil?.formatted(date: .long, time: .omitted)
              ?? String(localized: "document.noDeferment", bundle: .main)
          )
        )
        .font(.subheadline)
        if viewModel.isQRVisible {
          QRCodeView(data: (try? person.qrPayload()) ?? Data())
        } else {
          Button(String(localized: "document.showQR", bundle: .main)) {
            viewModel.toggleQR()
          }
        }
      } else {
        ProgressView()
          .task { await viewModel.load() }
      }
    }
    .padding()
    .navigationTitle(String(localized: "document.title", bundle: .main))
  }
}

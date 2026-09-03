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

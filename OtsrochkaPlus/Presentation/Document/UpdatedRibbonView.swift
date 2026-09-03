import SwiftUI

/// Ribbon showing "Документи оновлено: <today>" rendered dynamically from Date.now.
struct UpdatedRibbonView: View {
  var date: Date

  var body: some View {
    Text(
      String(
        format: String(localized: "document.updated", bundle: .main),
        date.formatted(date: .long, time: .omitted)
      )
    )
    .font(.footnote)
    .padding(.horizontal, 12)
    .padding(.vertical, 6)
    .background(.thinMaterial)
    .clipShape(Capsule())
  }
}

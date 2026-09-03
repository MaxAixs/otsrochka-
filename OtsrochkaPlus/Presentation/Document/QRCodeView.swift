import CoreImage.CIFilterBuiltins
import SwiftUI

/// QR code generated locally with CIQRCodeGenerator (no 3rd party).
struct QRCodeView: View {
  var data: Data

  var body: some View {
    if let image = generateQRCode(from: data) {
      image
        .interpolation(.none)
        .resizable()
        .scaledToFit()
        .frame(width: 220, height: 220)
        .accessibilityLabel(String(localized: "document.qr", bundle: .main))
    } else {
      ContentUnavailableView(
        String(localized: "document.qrError", bundle: .main),
        systemImage: "qrcode.viewfinder"
      )
    }
  }

  private func generateQRCode(from data: Data) -> Image? {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    filter.message = data
    filter.correctionLevel = "M"
    guard
      let output = filter.outputImage,
      let cgImage = context.createCGImage(output, from: output.extent)
    else {
      return nil
    }
    #if canImport(UIKit)
    return Image(uiImage: UIImage(cgImage: cgImage, scale: 1, orientation: .up))
    #else
    return Image(cgImage: cgImage, scale: 1, label: Text("QR"))
    #endif
  }
}

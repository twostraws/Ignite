//
// QRCodeEngine.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

#if canImport(CoreImage)
import CoreImage

/// The engine responsible for generating QR codes using CoreImage.
struct QRCodeEngine {
    /// The Core Image context.
    private let context = CIContext()

    /// The QR code generator filter.
    private let filter = CIFilter(name: "CIQRCodeGenerator")!

    /// Generates a QR code from a text string.
    /// - Parameters:
    ///   - text: The string to encode.
    ///   - errorCorrection: The level of error correction to use.
    /// - Returns: A boolean matrix representing the QR code.
    /// - Throws: `QRCodeError` if generation fails.
    func generate(text: String, errorCorrection: ErrorCorrection) throws -> BoolMatrix {
        guard let data = text.data(using: .utf8) else {
            throw QRCodeError.unableToConvertTextToRequestedEncoding
        }
        return try self.generate(data: data, errorCorrection: errorCorrection)
    }

    /// Generates a QR code from raw data.
    /// - Parameters:
    ///   - data: The data to encode.
    ///   - errorCorrection: The level of error correction to use.
    /// - Returns: A boolean matrix representing the QR code.
    /// - Throws: `QRCodeError` if generation fails.
    private func generate(data: Data, errorCorrection: ErrorCorrection) throws -> BoolMatrix {
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(errorCorrection.level, forKey: "inputCorrectionLevel")

        guard
            let outputImage = filter.outputImage,
            let qrImage = context.createCGImage(outputImage, from: outputImage.extent)
        else {
            throw QRCodeError.cannotGenerateImage
        }

        let width = qrImage.width
        let height = qrImage.height
        let colorspace = CGColorSpaceCreateDeviceGray()

        var rawData = [UInt8](repeating: 0, count: width * height)
        try rawData.withUnsafeMutableBytes { rawBufferPointer in
            let rawPtr = rawBufferPointer.baseAddress!
            guard let context = CGContext(
                data: rawPtr,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: width,
                space: colorspace,
                bitmapInfo: 0)
            else {
                throw QRCodeError.cannotGenerateImage
            }
            context.draw(qrImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }

        return BoolMatrix(dimension: width, flattened: rawData.map { $0 == 0 ? true : false })
    }
}
#endif

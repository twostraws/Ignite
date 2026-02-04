//
// QRCode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

#if canImport(CoreImage)
import CoreImage

/// A class for generating and manipulating QR codes.
///
/// Use `QRCode` to create QR codes from strings with varying levels of error correction.
/// The generated QR codes can be accessed as a boolean matrix or as ASCII art.
///
/// ```swift
/// let qrCode = try QRCode(utf8String: "https://example.com")
/// print(qrCode.smallAsciiRepresentation())
/// ```
struct QRCode {
    /// Creates a QR code with the specified UTF-8 string.
    /// - Parameters:
    ///   - utf8String: The string to encode in the QR code.
    ///   - errorCorrection: The level of error correction to use. Defaults to `.default`.
    /// - Throws: `QRCodeError` if generation fails.
    init(utf8String: String, errorCorrection: ErrorCorrection = .default) throws {
        try self.update(text: utf8String, errorCorrection: errorCorrection)
    }

    /// The current QR code as a boolean matrix.
    private var current = BoolMatrix()

    /// The current error correction level.
    private var currentErrorCorrection: ErrorCorrection = .default

    /// Updates the QR code with new text and settings.
    /// - Parameters:
    ///   - text: The string to encode in the QR code.
    ///   - textEncoding: The encoding to use for the text. Defaults to `.utf8`.
    ///   - errorCorrection: The level of error correction to use. Defaults to `.default`.
    /// - Throws: `QRCodeError` if generation fails.
    private mutating func update(
        text: String,
        textEncoding: String.Encoding = .utf8,
        errorCorrection: ErrorCorrection = .default
    ) throws {
        self.current = try self.generate(text: text, errorCorrection: errorCorrection)
        self.currentErrorCorrection = errorCorrection
    }

    /// Returns a string representation of the QR code using block characters.
    /// - Returns: A multiline string where filled blocks represent QR code dots.
    func asciiRepresentation() -> String {
        var result = ""
        for row in 0 ..< self.current.dimension {
            for col in 0 ..< self.current.dimension {
                result += self.current[row, col] ? "██" : "  "
            }
            result += "\n"
        }
        return result
    }

    /// Returns a compact string representation using half-block characters.
    /// - Returns: A multiline string with half-block characters for a more compact representation.
    func smallAsciiRepresentation() -> String {
        var result = ""
        for row in stride(from: 0, to: self.current.dimension, by: 2) {
            for col in 0 ..< self.current.dimension {
                let top = self.current[row, col]
                if row <= self.current.dimension - 2 {
                    let bottom = self.current[row + 1, col]
                    if top, !bottom { result += "▀" }
                    if !top, bottom { result += "▄" }
                    if top, bottom { result += "█" }
                    if !top, !bottom { result += " " }
                } else {
                    result += top ? "▀" : " "
                }
            }
            result += "\n"
        }
        return result
    }

    /// Generates a QR code from a text string.
    /// - Parameters:
    ///   - text: The string to encode.
    ///   - errorCorrection: The level of error correction to use.
    /// - Returns: A boolean matrix representing the QR code.
    /// - Throws: `QRCodeError` if generation fails.
    private func generate(text: String, errorCorrection: ErrorCorrection) throws -> BoolMatrix {
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
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(errorCorrection.level, forKey: "inputCorrectionLevel")

        guard
            let outputImage = filter.outputImage,
            let qrImage = CIContext().createCGImage(outputImage, from: outputImage.extent)
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

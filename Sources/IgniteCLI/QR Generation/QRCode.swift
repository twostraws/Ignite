//
// QRCode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
    /// The engine used to generate the QR code.
    private var engine = QRCodeEngine()

    /// Creates an empty QR code instance.
    init() {}

    /// Creates a QR code with the specified UTF-8 string.
    /// - Parameters:
    ///   - utf8String: The string to encode in the QR code.
    ///   - errorCorrection: The level of error correction to use. Defaults to `.default`.
    ///   - engine: An optional custom engine to use for generation. Defaults to nil.
    /// - Throws: `QRCodeError` if generation fails.
    init(
        utf8String: String,
        errorCorrection: ErrorCorrection = .default,
        engine: QRCodeEngine? = nil
    ) throws {
        if let engine = engine { self.engine = engine }
        try self.update(text: utf8String, errorCorrection: errorCorrection)
    }

    /// The current QR code as a boolean matrix.
    private(set) var current = BoolMatrix()

    /// Returns the current QR code boolean matrix.
    private var boolMatrix: BoolMatrix { self.current }

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
        self.current = try self.engine.generate(text: text, errorCorrection: errorCorrection)
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
}

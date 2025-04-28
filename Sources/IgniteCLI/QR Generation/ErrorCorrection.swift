//
// ErrorCorrection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The level of error correction to use in a QR code.
///
/// QR codes can incorporate different levels of error correction, allowing the code
/// to be read even when partially damaged or obscured.
enum ErrorCorrection: Int, CaseIterable, Sendable {
    /// Low level error correction. Approximately 7% of data can be restored.
    case low = 0

    /// Medium level error correction. Approximately 15% of data can be restored.
    case medium = 1

    /// Quantize level error correction. Approximately 25% of data can be restored.
    case quantize = 2

    /// High level error correction. Approximately 30% of data can be restored.
    case high = 3

    /// The default error correction level (`.quantize`).
    static let `default` = ErrorCorrection.quantize

    /// The CoreImage error correction string representation.
    var level: String {
        switch self {
        case .low: return "L"
        case .medium: return "M"
        case .quantize: return "Q"
        case .high: return "H"
        }
    }
}

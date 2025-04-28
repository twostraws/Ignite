//
// QRCodeError.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Errors that can occur during QR code generation.
enum QRCodeError: Error {
    /// A generic error when QR code generation fails.
    case cannotGenerateQRCode

    /// When text cannot be encoded using the specified encoding.
    case unableToConvertTextToRequestedEncoding

    /// When the CoreImage filter fails to produce an output image.
    case cannotGenerateImage
}

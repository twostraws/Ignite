//
// HTTPStatusCodeError.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A basic implementation of an HTTP status code error.
public struct HTTPStatusCodeError: StatusCodeError {
    public let filename: String
    public let title: String
    public let description: String
}

// MARK: - Default Error Statuses

public extension HTTPStatusCodeError {

    /// The HTTP status code when a page could not be found.
    static let notFound: HTTPStatusCodeError = .init(filename: "404", title: "Page Not Found", description: "The page you are looking for could not be found.")

    /// The HTTP status code when an internal server error occurred.
    static let internalServerError: HTTPStatusCodeError = .init(filename: "500", title: "Internal Server Error", description: "The server encountered an internal error. Please try again later.")
}

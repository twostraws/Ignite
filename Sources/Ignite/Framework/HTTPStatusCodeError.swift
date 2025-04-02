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

    public init(_ code: Int, title: String, description: String) {
        self.filename = String(code)
        self.title = title
        self.description = description
    }
}

// MARK: - Default Error Statuses

public extension StatusCodeError where Self == HTTPStatusCodeError {

    /// The status code error when a page could not be found.
    static var pageNotFound: StatusCodeError {
        HTTPStatusCodeError(
            404,
            title: "Page Not Found",
            description: "The page you are looking for could not be found."
        )
    }

    /// The status code error when an internal server error occurred.
    static var internalServerError: StatusCodeError {
        HTTPStatusCodeError(
            500,
            title: "Internal Server Error",
            description: "The server encountered an internal error. Please try again later."
        )
    }
}

//
// PageNotFoundError.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An HTTP error that represents a page not found.
public struct PageNotFoundError: HTTPError {
    public let statusCode: Int
    public let title: String
    public let description: String

    public init() {
        self.statusCode = 404
        self.title = "Page Not Found"
        self.description = "The page you are looking for could not be found."
    }
}

public extension HTTPError where Self == PageNotFoundError {
    /// An HTTP error that represents a page not found.
    static var pageNotFound: HTTPError {
        PageNotFoundError()
    }
}

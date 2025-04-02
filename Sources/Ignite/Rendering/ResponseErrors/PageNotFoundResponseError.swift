//
// PageNotFoundError.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A response error that represents a page not found.
public struct PageNotFoundResponseError: ResponseError {
    public let filename: String
    public let title: String
    public let description: String

    public init() {
        self.filename = "404"
        self.title = "Page Not Found"
        self.description = "The page you are looking for could not be found."
    }
}

public extension ResponseError where Self == PageNotFoundResponseError {
    /// A response error that represents a page not found.
    static var pageNotFound: ResponseError {
        PageNotFoundResponseError()
    }
}

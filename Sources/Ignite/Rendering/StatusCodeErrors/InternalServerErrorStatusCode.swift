//
// InternalServerErrorStatusCode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A status code representing an internal server error.
public struct InternalServerErrorStatusCode: StatusCodeError {
    public let filename: String
    public let title: String
    public let description: String

    public init() {
        self.filename = "500"
        self.title = "Internal Server Error"
        self.description = "The server encountered an internal error. Please try again later."
    }
}

public extension StatusCodeError where Self == InternalServerErrorStatusCode {
    /// A status code representing an internal server error.
    static var internalServerError: StatusCodeError {
        InternalServerErrorStatusCode()
    }
}

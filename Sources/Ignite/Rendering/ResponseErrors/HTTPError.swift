//
// ErrorPageStatus.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents an HTTP status code error that can be displayed as an error page.
public protocol HTTPError: Sendable {

    /// The status code of the HTTP error.
    var statusCode: Int { get }

    /// The title of the error.
    var title: String { get }

    /// The description of the error.
    var description: String { get }
}

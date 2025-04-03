//
// ErrorPageStatus.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents an HTTP status code error that can be displayed as an error page.
public protocol HTTPError: Sendable {

    /// The filename of the generated error page.
    var filename: String { get }

    /// The title of the error.
    var title: String { get }

    /// The description of the error.
    var description: String { get }
}

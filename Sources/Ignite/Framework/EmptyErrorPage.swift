//
// EmptyErrorPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A default error page that does nothing.
public struct EmptyErrorPage: ErrorPage {

    public init() {}

    public var title: String {
        ""
    }

    public var body: some HTML {
        EmptyHTML()
    }
}

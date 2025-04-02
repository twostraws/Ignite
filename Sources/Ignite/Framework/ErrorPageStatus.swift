//
// ErrorPageStatus.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An enumeration representing the various error pages that can be displayed.
public enum ErrorPageStatus: Int, Sendable, CaseIterable {

    /// The status when a page was not found (404).
    case pageNotFound = 404

    /// The status when the server encountered an internal error (500).
    case internalServerError = 500

    /// The title of the error page.
    public var title: String {
        switch self {
        case .pageNotFound:
            return "Page Not Found"

        case .internalServerError:
            return "Internal Server Error"
        }
    }

    /// The description of the error page.
    public var description: String {
        switch self {
        case .pageNotFound:
            return "The page you are looking for could not be found."

        case .internalServerError:
            return "The server encountered an internal error. Please try again later."
        }
    }
}

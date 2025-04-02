//
// ErrorPageStatus.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An type representing the status of an error page that can be displayed.
public struct ErrorPageStatus: Sendable, CaseIterable {

    /// The filename of the generated error page.
    ///
    /// - important: The extension of the file is added automatically. Do not include it in the filename.
    public let filename: String

    /// The title of the error page.
    public let title: String

    /// The description of the error page.
    public let description: String

    public init(filename: String, title: String, description: String) {
        self.filename = filename
        self.title = title
        self.description = description
    }

    public static var allCases: [ErrorPageStatus] {
        [
            .pageNotFound,
            .internalServerError
        ]
    }
}

// MARK: - Default Error Statuses

public extension ErrorPageStatus {

    /// The status when a page could not be found.
    static let pageNotFound = ErrorPageStatus(filename: "404", title: "Page Not Found", description: "The page you are looking for could not be found.")

    /// The status when an internal server error occurred.
    static let internalServerError = ErrorPageStatus(filename: "500", title: "Internal Server Error", description: "The server encountered an internal error. Please try again later.")

}

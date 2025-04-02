//
// ErrorPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Error pages are special pages that are shown when a specific HTTP status code is encountered.
/// They are used to provide a custom error message or page to the user.
/// For example, a 404 error page can be used to inform the user that the requested page was not found.
///
/// ```swift
/// struct MyErrorPage: ErrorPage {
///     var body: some HTML {
///         Section {
///             Text(error.title).font(.title1)
///             Text(error.description)
///             Link("Go back to the homepage", destination: "/")
///                 .buttonStyle(.primary)
///         }
///     }
/// }
/// ```
@MainActor
public protocol ErrorPage: StaticPage {
    /// The current error page being rendered.
    var error: ErrorPageStatus { get }
}

extension ErrorPage {
    public var title: String {
        error.title
    }

    public var path: String {
        ""
    }

    public var error: ErrorPageStatus {
        PublishingContext.shared.environment.errorPageStatus
    }
}

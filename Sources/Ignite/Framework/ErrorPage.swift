//
// ErrorPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Allows you to define a custom error page for your site.
///
/// The error page is a  special page that is shown when a specific status code or error is encountered.
///
/// ```swift
/// struct MyErrorPage: ErrorPage {
///   var body: some HTML {
///     Section {
///       Text(error.title).font(.title1)
///       Text(error.description)
///       Link("Go back to the homepage", destination: "/")
///         .buttonStyle(.primary)
///     }
///   }
/// }
/// ```
///
/// Ignite currently only supports a 404 response error
@MainActor
public protocol ErrorPage: LayoutContent {
    /// The current response error being rendered.
    var error: ResponseError { get }

    /// The title of the error page. Defaults to the title of the error.
    var title: String { get }

    /// The description of the error page. Defaults to the description of the error.
    var description: String { get }
}

extension ErrorPage {
    public var error: ResponseError {
        PublishingContext.shared.environment.responseError
    }

    public var title: String {
        error.title
    }

    public var description: String {
        error.description
    }
}

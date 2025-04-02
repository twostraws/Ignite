//
// ErrorPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Allows you to define a custom error page for your site.
///
/// The error page is a  special page that is shown when a specific HTTP status code is encountered.
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
///
/// Ignite supports a few basic error statuses such as 404 and 500, but you can also create your own by adding them under your Site's `supportedErrorStatuses` property.
///
/// ```swift
/// extension ErrorPageStatus {
///     static let unauthorized = ErrorPageStatus(filename: "401", title: "Unauthorized", description: "You don't have permission to access this page.")
/// }
///
/// struct MySite: Site {
///     var supportedErrorStatuses: [ErrorPageStatus] {
///         [.unauthorized]
///     }
/// }
@MainActor
public protocol ErrorPage: LayoutContent {
    /// The current status code error being rendered.
    var error: StatusCodeError { get }
}

extension ErrorPage {
    public var title: String {
        error.title
    }

    public var path: String {
        ""
    }

    public var error: StatusCodeError {
        PublishingContext.shared.environment.statusCodeError
    }
}

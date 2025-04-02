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
/// Ignite supports a few basic status code errors such as 404 and 500, but you can also create your own by extending the `StatusCodeError` protocol.
///
/// ```swift
/// struct extension StatusCodeError where Self == HTTPStatusCodeError {
///   static var unauthorized: StatusCodeError {
///     HTTPStatusCodeError(
///       401,
///       title: "Unauthorized",
///       description: "You don't have permission to access this page."
///     )
///   }
/// }
///
/// struct MySite: Site {
///   var supportedErrorStatuses: [StatusCodeError] {
///     [.unauthorized]
///   }
/// }
/// ```
///
/// You could also create a completely custom status code error type by conforming to the `StatusCodeError` protocol directly.
///
/// ```swift
/// struct MyCustomError: StatusCodeError {
///   var filename: String { "my-custom-error" }
///   var title: String { "My Custom Error" }
///   var description: String { "This is a custom error that I created." }
///   var someOtherProperty: String { "This is a custom property." }
/// }
///
/// struct MySite: Site {
///    var supportedErrorStatuses: [StatusCodeError] {
///        [MyCustomError()]
///    }
///  }
/// ```
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

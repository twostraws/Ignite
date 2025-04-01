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
///     var title: "Page Not Found"
///     var filename: "404"
/// 
///     var body: some HTML {
///         Section {
///             Text("404 - Page Not Found").font(.title1)
///             Text("Sorry, the page you are looking for does not exist.")
///             Link("Go back to the homepage", destination: "/")
///                 .buttonStyle(.primary)
///         }
///     }
/// }
/// ```
@MainActor
public protocol ErrorPage: StaticPage {
    /// The filename of the error page, such as "404" for a 404 error page.
    /// 
    /// This property represents the name of the error page file, which will be saved 
    /// as an HTML file (e.g., `404.html`) in the specified output directory. It is 
    /// used to uniquely identify and locate the error page within the generated output.
    var filename: String { get }
}

extension ErrorPage {
    public var path: String {
        ""
    }
}

//
// StyleManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A class that manages custom CSS styles for the application.
@MainActor
final class StyleManager {
    /// The shared instance of the style manager.
    static let `default` = StyleManager()

    /// The collection of custom CSS styles.
    private var customStyles: Set<String> = []

    /// Adds a new CSS style rule to the manager.
    /// - Parameter style: The CSS style rule to add
    func addStyle(_ style: String) {
        customStyles.insert(style)
    }

    /// Whether any custom styles have been registered.
    var hasStyles: Bool {
        return !customStyles.isEmpty
    }

    /// Writes all registered styles to a CSS file.
    /// - Parameter buildDirectory: The directory where the CSS file should be written
    /// - Throws: An error if the file cannot be written
    func writeStyles(to buildDirectory: URL) throws {
        let cssPath = buildDirectory.appending(path: "css/custom.min.css")
        let cssContent = customStyles.joined(separator: "\n\n")
        try cssContent.write(to: cssPath, atomically: true, encoding: .utf8)
    }
}

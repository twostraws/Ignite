//
// StyleManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A class that manages the registration and generation of CSS styles.
///
/// StyleManager maintains a collection of registered styles and handles their conversion
/// to CSS rules. It ensures styles are only registered once and manages writing the
/// final CSS output to disk during site generation.
@MainActor
final class StyleManager {
    /// The shared instance used for style management across the application.
    public static let `default` = StyleManager()

    /// Set of registered style class names to prevent duplicates.
    private var registeredStyles: Set<String> = []

    /// Collection of CSS rules waiting to be written to the output file.
    private var pendingRules: [String] = []

    /// Returns true if any styles have been registered
    var hasStyles: Bool {
        return !registeredStyles.isEmpty
    }

    /// Registers a resolved style if it hasn't been registered before.
    /// - Parameter style: The resolved style to register
    func registerStyle(_ style: ResolvedStyle) {
        guard !registeredStyles.contains(style.className) else { return }
        registeredStyles.insert(style.className)
        pendingRules.append(style.cssRule)
    }

    /// Registers any style by attempting to resolve it first.
    /// - Parameter style: The style to register
    func registerStyle(_ style: some Style) {
        guard !registeredStyles.contains(style.className) else { return }
        let resolvedStyle = (style as? ResolvedStyle) ??
        (style.body as? ResolvedStyle) ?? ResolvedStyle()
        registerStyle(resolvedStyle)
    }

    /// Writes all pending CSS rules to the output file.
    /// - Parameter file: The URL where the CSS should be written.
    func write(to file: URL) {
        guard !pendingRules.isEmpty else { return }

        let existingContent = (try? String(contentsOf: file)) ?? ""

        let newRules = pendingRules.joined(separator: "\n\n")
        let cssContent = """
        \(existingContent)
        
        \(newRules)
        """
        try? cssContent.write(to: file, atomically: true, encoding: .utf8)
        pendingRules.removeAll()
    }
}

//
// StyleManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
final class StyleManager {
    static let `default` = StyleManager()
    private var customStyles: Set<String> = []

    func addStyle(_ style: String) {
        customStyles.insert(style)
    }

    /// Returns true if any styles have been registered
    var hasStyles: Bool {
        return !customStyles.isEmpty
    }

    func writeStyles(to buildDirectory: URL) throws {
        let cssPath = buildDirectory.appending(path: "css/custom.min.css")
        let cssContent = customStyles.joined(separator: "\n\n")
        try cssContent.write(to: cssPath, atomically: true, encoding: .utf8)
    }
}

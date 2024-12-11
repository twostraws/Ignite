//
// EnvironmentEffect.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum MediaQuery {
    case darkMode
    case lightMode
    case reducedMotion
    case reducedTransparency
    case reducedContrast
    case highContrast

    var query: String {
        switch self {
        case .darkMode: "prefers-color-scheme: dark"
        case .lightMode: "prefers-color-scheme: light"
        case .reducedMotion: "prefers-reduced-motion: reduce"
        case .reducedTransparency: "prefers-reduced-transparency: reduce"
        case .reducedContrast: "prefers-contrast: less"
        case .highContrast: "prefers-contrast: more"
        }
    }
}

struct EnvironmentEffectModifier: HTMLModifier {
    private let mediaQueries: [MediaQuery]
    private let modifications: (any HTML) -> any HTML

    init(mediaQueries: [MediaQuery], modifications: @escaping (any HTML) -> any HTML) {
        self.mediaQueries = mediaQueries
        self.modifications = modifications
    }

    func body(content: some HTML) -> any HTML {
        // Generate unique class name for this modification
        let className = "env-\(content.id)"

        // Apply modifications to get the changed attributes
        var copy = EmptyHTML()
        let modifiedContent = modifications(copy)
        var modifiedAttributes: CoreAttributes
        if let modifiedContent = modifiedContent as? ModifiedHTML {
            modifiedAttributes = modifiedContent.content.attributes
        } else {
            modifiedAttributes = modifiedContent.attributes
        }

        // Get only the new/changed attributes
        let originalAttributes = AttributeStore.default.attributes(for: content.id)
        let newStyles = modifiedAttributes.styles.subtracting(originalAttributes.styles)
        // Create media query CSS
        let styleRules = newStyles.map { "\($0.name): \($0.value);" }.joined(separator: " ")
        let mediaQueryString = mediaQueries.map { "(\($0.query))" }.joined(separator: " and ")

        let cssRule = """
            @media \(mediaQueryString) {
                .\(className) { \(styleRules) }
            }
            """

        // Add to custom.css via publishing context
        StyleManager.default.addStyle(cssRule)

        return content.class(className)
    }
}

public extension HTML {
    func environmentEffect(_ mediaQueries: MediaQuery..., modifications: @escaping (any HTML) -> any HTML) -> some HTML {
        modifier(EnvironmentEffectModifier(mediaQueries: mediaQueries, modifications: modifications))
    }
}

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

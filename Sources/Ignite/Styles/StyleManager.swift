//
// StyleManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import DartSass

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

    /// Set of registered CSS variable names to prevent duplicates.
    private var registeredColors: Set<String> = []

    /// Collection of CSS variable declarations waiting to be written to the output file.
    private var pendingColors: [String] = []

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
        let resolvedStyle = (style.body as? ResolvedStyle) ?? ResolvedStyle()
        registerStyle(resolvedStyle)
    }

    @MainActor func registerColorVariant(color: String, weight: Int, function: String, percentage: Int) {
        let key = "\(color)-\(weight)"
        if !registeredColors.contains(key) {
            registeredColors.insert(key)
            pendingColors.append("--bs-\(key): #{\(function)($\(color), \(percentage)%)}")
        }
    }

    /// Writes all pending CSS rules to the output file.
    /// - Parameter file: The URL where the CSS should be written.
    func write(to file: URL) async throws {
        var cssContent = """
        // Base colors
        $white: #fff;
        $black: #000;
        
        // Bootstrap base colors
        $blue: #0d6efd;
        $indigo: #6610f2;
        $purple: #6f42c1;
        $pink: #d63384;
        $red: #dc3545;
        $orange: #fd7e14;
        $yellow: #ffc107;
        $green: #198754;
        $teal: #20c997;
        $cyan: #0dcaf0;
        $gray: #adb5bd;
        
        // Color functions
        @function tint-color($color, $weight) {
            $value: mix($white, $color, $weight);
            @return rgb(round(red($value)), round(green($value)), round(blue($value)));
        }
        
        @function shade-color($color, $weight) {
            $value: mix($black, $color, $weight);
            @return rgb(round(red($value)), round(green($value)), round(blue($value)));
        }
        
        :root {
            // Add only the used color variants
            \(pendingColors.joined(separator: "\n        "))
        }
        """

        if !pendingRules.isEmpty {
            cssContent += "\n\n\(pendingRules.joined(separator: "\n\n"))"
        }

        pendingColors.removeAll()
        pendingRules.removeAll()
        registeredColors.removeAll()

        let compiler = try Compiler()
        let result = try await compiler.compile(string: cssContent)
        try result.css.write(to: file, atomically: true, encoding: .utf8)
    }
}

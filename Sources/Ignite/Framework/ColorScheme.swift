//
// ColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public enum ColorScheme: String, CustomStringConvertible {
    case auto, light, dark
    
    public var description: String {
        rawValue
    }
}

public extension Body {
    func colorScheme(_ colorScheme: ColorScheme) -> Self {
        var copy = self
        switch colorScheme {
        case .auto:
            copy.items.append(setBasedOnUserPreference())
        default:
            copy.items.append(setColorSchema(colorScheme))
        }
        return copy
    }

    func setColorSchema(_ colorSchema: ColorScheme) -> Script {
        Script(code: "document.documentElement.setAttribute('data-bs-theme', '\(colorSchema)');")
    }

    func setBasedOnUserPreference() -> Script {
        Script(code: """
        document.addEventListener('DOMContentLoaded', (event) => {
            // Function to set the theme based on user preference
            function setThemeBasedOnPreference() {
                const prefersDarkScheme = window.matchMedia('(prefers-color-scheme: dark)').matches;

                if (prefersDarkScheme) {
                    document.documentElement.setAttribute('data-bs-theme', 'dark');
                } else {
                    document.documentElement.setAttribute('data-bs-theme', 'light');
                }
            }

            // Set the theme based on user preference when the page loads
            setThemeBasedOnPreference();

            // Listen for changes to the user's color scheme preference
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', setThemeBasedOnPreference);
        });
        """)
    }
}

public extension PageElement {
    func colorScheme(_ colorScheme: ColorScheme) -> Self {
        data("bs-theme", "\(colorScheme)")
    }
}

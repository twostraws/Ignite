//
// String-TitleCase.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension String {
    /// Converts a string from PascalCase to Title Case with spaces
    func titleCase() -> String {
        self.replacing(
            #/([a-z0-9]|[A-Z])([A-Z][a-z]|[A-Z])/#,
            with: { match in
                "\(match.1) \(match.2)"
            }
        )
    }
}

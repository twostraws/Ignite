//
// ButtonSize.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Controls the display size of buttons. Medium is the default.
public enum ButtonSize: String, Sendable, CaseIterable {
    case small, medium, large

    /// Returns an array containing the correct CSS classes to style this button
    /// based on the role and size passed in. This is used for buttons, links, and
    /// dropdowns, which is why it's shared.
    /// - Parameters:
    ///   - role: The role we are styling.
    ///   - size: The size we are styling.
    /// - Returns: The CSS classes to apply for this button
    func classes(forRole role: Role) -> [String] {
        var outputClasses = ["btn"]

        switch self {
        case .small:
            outputClasses.append("btn-sm")
        case .large:
            outputClasses.append("btn-lg")
        default:
            break
        }

        switch role {
        case .default, .none:
           break
        default:
            outputClasses.append("btn-\(role.rawValue)")
        }

        return outputClasses
    }
}

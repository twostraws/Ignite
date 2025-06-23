//
// LinkStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The visual style to apply to the link.
public enum LinkStyle: Equatable, Sendable {
    /// A link with an underline effect.
    /// - Parameters:
    ///   - base: The underline prominence in the link's normal state.
    ///   - hover: The underline prominence when hovering over the link.
    case underline(_ default: UnderlineProminence, hover: UnderlineProminence)

    /// A link that appears and behaves like a button.
    case button

    /// Creates an underline-style link with uniform prominence for both normal and hover states.
    /// - Parameter prominence: The underline prominence to use for both states.
    /// - Returns: A `LinkStyle` with identical base and hover prominence.
    public static func underline(_ prominence: UnderlineProminence) -> Self {
        .underline(prominence, hover: prominence)
    }

    /// The default link style with heavy underline prominence.
    public static var automatic: Self { .underline(.heavy, hover: .heavy) }
}

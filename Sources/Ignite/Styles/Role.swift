//
// Role.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Roles let us attach semantic meaning to various elements, which Bootstrap
/// uses to add specific styling. For example, `.danger` elements will be
/// colored some shade of red.
public enum Role: String, CaseIterable {
    /// No specific role has been attached.
    case `default`

    /// A primary element.
    case primary

    /// A secondary element.
    case secondary

    /// Represents a close element
    case close

    /// This element represents the successful result of something, or otherwise
    /// positive information.
    case success

    /// This element represents the unsuccessful result of something, or otherwise
    /// information that the user must consider carefully.
    case danger

    /// This element represents a warning – something might have gone mildly
    /// wrong, or you want to make sure they are aware of an important piece
    /// of information.
    case warning

    /// This element represents information, and has neither positive nor negative
    /// connotations.
    case info

    /// This element should be rendered in light colors.
    case light

    /// This element should be rendered in dark colors.
    case dark

    /// This element should be rendered as regular text.
    case none

    /// A list of roles that are useful for Badge elements.
    @MainActor
    public static let badgeRoles: [Role] = [
        .primary, .secondary, .success, .danger, .warning, .info, .light, .dark
    ]
}

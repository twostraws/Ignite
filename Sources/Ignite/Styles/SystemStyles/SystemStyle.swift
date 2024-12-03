//
// SystemStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Base style for system-provided classes that wraps Bootstrap utility classes
public struct SystemStyle: Style {
    /// The CSS class name to apply from Bootstrap's utility classes
    public let className: String

    /// Creates a new system style with the specified Bootstrap class name
    /// - Parameter className: The Bootstrap utility class name to use
    internal init(_ className: String) {
        self.className = className
    }

    /// Resolves this style into its concrete form
    public var body: some Style {
        ResolvedStyle(className: className)
    }
}

/// Bootstrap text and background styles
public extension Style where Self == SystemStyle {
    /// Primary text color style
    static var primary: Self { .init("text-primary") }

    /// Emphasized primary text color style
    static var primaryEmphasis: Self { .init("text-primary-emphasis") }

    /// Secondary text color style
    static var secondary: Self { .init("text-body-secondary") }

    /// Tertiary text color style
    static var tertiary: Self { .init("text-body-tertiary") }

    /// Success text color style
    static var success: Self { .init("text-success") }

    /// Emphasized success text color style
    static var successEmphasis: Self { .init("text-success-emphasis") }

    /// Danger/error text color style
    static var danger: Self { .init("text-danger") }

    /// Emphasized danger/error text color style
    static var dangerEmphasis: Self { .init("text-danger-emphasis") }

    /// Warning text color style
    static var warning: Self { .init("text-warning") }

    /// Emphasized warning text color style
    static var warningEmphasis: Self { .init("text-warning-emphasis") }

    /// Info text color style
    static var info: Self { .init("text-info") }

    /// Emphasized info text color style
    static var infoEmphasis: Self { .init("text-info-emphasis") }

    /// Light text color style
    static var light: Self { .init("text-light") }

    /// Emphasized light text color style
    static var lightEmphasis: Self { .init("text-light-emphasis") }

    /// Dark text color style
    static var dark: Self { .init("text-dark") }

    /// Emphasized dark text color style
    static var darkEmphasis: Self { .init("text-dark-emphasis") }

    /// Default body text color style
    static var body: Self { .init("text-body") }

    /// Emphasized body text color style
    static var bodyEmphasis: Self { .init("text-body-emphasis") }

    /// Primary background color style
    static var primaryBackground: Self { .init("bg-primary") }

    /// Secondary background color style
    static var secondaryBackground: Self { .init("bg-secondary") }

    /// Success background color style
    static var successBackground: Self { .init("bg-success") }

    /// Danger/error background color style
    static var dangerBackground: Self { .init("bg-danger") }

    /// Warning background color style
    static var warningBackground: Self { .init("bg-warning") }

    /// Info background color style
    static var infoBackground: Self { .init("bg-info") }

    /// Light background color style
    static var lightBackground: Self { .init("bg-light") }

    /// Dark background color style
    static var darkBackground: Self { .init("bg-dark") }
}

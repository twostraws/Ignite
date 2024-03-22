//
// Alert.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Shows a clearly delineated box on your page, providing important information
/// or warnings to users.
public struct Alert: BlockElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    var content: [any PageElement]
    var role = Role.default

    var alertClasses: [String] {
        var outputClasses = ["alert"]

        outputClasses.append(contentsOf: attributes.classes.sorted())

        switch role {
        case .default:
            break

        default:
            outputClasses.append("alert-\(role.rawValue)")
        }

        return outputClasses

    }

    public init(@PageElementBuilder content: () -> [any PageElement]) {
        self.content = content()
    }

    public func role(_ role: Role) -> Alert {
        var copy = self
        copy.role = role
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        let alertAttributes = attributes.appending(classes: alertClasses)

        return Group {
            for item in content {
                item
            }
        }
        .attributes(alertAttributes)
        .render(context: context)
    }
}

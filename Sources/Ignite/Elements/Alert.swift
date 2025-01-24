//
// Alert.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Shows a clearly delineated box on your page, providing important information
/// or warnings to users.
public struct Alert: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    var content: any HTML

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

    public init(@HTMLBuilder content: () -> some HTML) {
        self.content = content()
    }

    public func role(_ role: Role) -> Alert {
        var copy = self
        copy.role = role
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        attributes.append(containerAttributes: .init(classes: alertClasses))
        return attributes.description(wrapping: content.render())
    }
}

extension Alert {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public func id(_ id: String) -> Self {
        attributes.id(id)
        return self
    }

    public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes)
        return self
    }
}

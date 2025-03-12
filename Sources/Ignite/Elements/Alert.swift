//
// Alert.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Shows a clearly delineated box on your page, providing important information
/// or warnings to users.
public struct Alert: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    var content: any HTML

    var role = Role.default

    var alertClasses: [String] {
        var outputClasses = ["alert"]
        outputClasses.append(contentsOf: attributes.classes)

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
        Section(content)
            .class(alertClasses)
            .attributes(attributes)
            .render()
    }
}

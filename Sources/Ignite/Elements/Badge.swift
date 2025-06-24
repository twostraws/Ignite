//
// Badge.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A small, capsule-shaped piece of information, such as a tag.
public struct Badge<Content: InlineElement>: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    private var content: Content
    private var style = BadgeStyle.default
    private var role = Role.default

    private var badgeClasses: [String] {
        var outputClasses = ["badge"]
        outputClasses.append(contentsOf: attributes.classes)

        switch style {
        case .default:
            switch role {
            case .default:
                break

            default:
                outputClasses.append("text-bg-\(role.rawValue)")
            }

        case .subtle:
            switch role {
            case .default:
                outputClasses.append("bg-subtle")
                outputClasses.append("text-emphasis")

            default:
                outputClasses.append("bg-\(role.rawValue)-subtle")
                outputClasses.append("text-\(role.rawValue)-emphasis")
            }

        case .subtleBordered:
            switch role {
            case .default:
                outputClasses.append("bg-subtle")
                outputClasses.append("border")
                outputClasses.append("border-subtle")
                outputClasses.append("text-emphasis")

            default:
                outputClasses.append("bg-\(role.rawValue)-subtle")
                outputClasses.append("border")
                outputClasses.append("border-\(role.rawValue)-subtle")
                outputClasses.append("text-\(role.rawValue)-emphasis")
            }
        }

        outputClasses.append("rounded-pill")
        return outputClasses
    }

    public init(_ content: Content) {
        self.content = content
    }

    public init(_ content: String) where Content == String {
        self.content = content
    }

    public func role(_ role: Role) -> Self {
        var copy = self
        copy.role = role
        return copy
    }

    public func badgeStyle(_ style: BadgeStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let badgeAttributes = attributes.appending(classes: badgeClasses)
        return Span(content)
            .attributes(badgeAttributes)
            .render()
    }
}

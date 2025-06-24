//
// ControlGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that has a distinct configuration when housed in a `ControlGroup`.
@MainActor
protocol ControlGroupItemConfigurable {
    func configuredAsControlGroupItem(_ labelStyle: ControlLabelStyle) -> ControlGroupItem
}

/// A container that groups related form controls into a unified visual component.
public struct ControlGroup<Content: ControlGroupElement>: HTML {
    /// Defines the size variants available for control groups.
    public enum ControlSize: String, Sendable, CaseIterable {
        /// Creates a smaller, more compact control group.
        case small = "input-group-sm"
        /// Creates a standard-sized control group.
        case medium = ""
        /// Creates a larger, more expanded control group.
        case large = "input-group-lg"
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The label text for the control group.
    private let label: String?

    /// The help text displayed below the control group.
    private var helpText: String?

    /// The collection of form items contained within this control group.
    private let content: Content

    /// The size configuration for the control group.
    private var size: ControlSize?

    /// The style used for displaying labels.
    private var labelStyle: ControlLabelStyle = .floating

    /// Creates a control group with an optional label and the specified form items.
    /// - Parameters:
    ///   - label: An optional label describing the purpose of the control group.
    ///   - items: A closure returning an array of form items to include in the group.
    public init(
        _ label: String? = nil,
        @ControlGroupElementBuilder content: () -> Content
    ) {
        self.label = label
        self.content = content()
        self.helpText = nil
    }

    /// Sets the size of the control group.
    /// - Parameter size: The desired size for the control group.
    /// - Returns: A modified control group with the specified size.
    public func controlSize(_ size: ControlSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Adds descriptive help text below the control group.
    /// - Parameter text: The help text to display, or nil to remove existing help text.
    /// - Returns: A modified control group with the specified help text.
    public func helpText(_ text: String?) -> Self {
        var copy = self
        copy.helpText = text
        return copy
    }

    /// Sets the style for displaying labels within the control group.
    /// - Parameter style: The label style to apply to the control group.
    /// - Returns: A modified control group with the specified label style.
    func labelStyle(_ style: ControlLabelStyle) -> Self {
        var copy = self
        copy.labelStyle = style
        return copy
    }

    public func render() -> Markup {
        var items = content.subviews().elements
        if let lastItem = items.last {
            items = items.dropLast()
            items.append(lastItem.configuredAsLastItem())
        }

        let content = Section {
            ForEach(items) { item in
                item
                    .configuredAsControlGroupItem(labelStyle)
            }
        }
        .attributes(attributes)
        .class("input-group")
        .class(size?.rawValue)

        guard label != nil || helpText != nil else {
            return content.render()
        }

        return Section {
            if let label {
                ControlLabel(label)
                    .class("form-label")
            }

            content

            if let helpText {
                Section(helpText)
                    .class("form-text")
            }
        }
        .render()
    }
}

extension ControlGroup: FormElementRenderable {
    func renderAsFormElement(_ configuration: FormConfiguration) -> Markup {
        self.labelStyle(configuration.labelStyle).render()
    }
}

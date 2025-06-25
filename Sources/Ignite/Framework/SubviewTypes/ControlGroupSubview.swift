//
// ControlGroupSubview.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque HTML element representing a subview of an `ControlGroup`.
struct ControlGroupSubview: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: any ControlGroupElement

    /// The underlying HTML content, with attributes.
    var wrapped: any ControlGroupElement {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    private var configuration = FormConfiguration()

    /// Creates a new `ControlGroupSubview` instance that wraps the given HTML content.
    /// - Parameter content: The HTML content to wrap
    init(_ wrapped: any ControlGroupElement) {
        self.content = wrapped
    }

    nonisolated func render() -> Markup {
        MainActor.assumeIsolated {
            return if let element = wrapped as? FormElementRenderable {
                element.renderAsFormElement(configuration)
            } else {
                wrapped.render()
            }
        }
    }

    /// Applies form configuration to this subview.
    /// - Parameter configuration: The form configuration to apply.
    /// - Returns: A configured copy of this subview.
    func formConfiguration(_ configuration: FormConfiguration) -> Self {
        var copy = self
        copy.configuration = configuration
        return copy
    }

    /// Configures this subview as a control group item with the specified label style.
    /// - Parameter labelStyle: The label style to apply.
    /// - Returns: A configured control group item.
    func configuredAsControlGroupItem(_ labelStyle: ControlLabelStyle) -> ControlGroupItem {
        if let item = wrapped as? any ControlGroupItemConfigurable {
            return item.configuredAsControlGroupItem(labelStyle)
        }
        return ControlGroupItem(self)
    }

    /// Configures this subview as the last item in a control group.
    /// - Returns: A configured copy of this subview.
    func configuredAsLastItem() -> Self {
        if var item = wrapped as? DropdownItemConfigurable {
            item.configuration = .lastControlGroupItem
            // swiftlint:disable:next force_cast
            return ControlGroupSubview(item as! ControlGroupElement)
        }
        return self
    }
}

extension ControlGroupSubview: Equatable {
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.render() == rhs.render()
    }
}

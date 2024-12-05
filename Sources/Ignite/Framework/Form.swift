//
// Form.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form container for collecting user input
public struct Form: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// How many columns this should be divided into
    private var columnCount: Int = 12

    /// The amount of vertical spacing between form elements.
    private var verticalSpacing: SpacingAmount

    /// The amount of horizontal spacing between form elements.
    private var horizontalSpacing: SpacingAmount

    /// The form elements to be rendered.
    private var items: [any InlineHTML]

    /// The action to perform when the form is submitted.
    private var action: (String) -> any Action

    /// The style of labels in the form
    private var labelStyle: LabelStyle = .floating

    /// The size of form controls and labels
    private var controlSize: FormControlSize = .medium

    /// Controls how form labels are displayed
    public enum LabelStyle {
        /// Labels appear above their fields
        case top
        /// Labels appear to the left of their fields
        case left
        /// Labels float when the field has content
        case floating
        /// No labels are shown
        case hidden
    }

    /// Controls the size of form controls and labels
    public enum FormControlSize {
        case small
        case medium
        case large

        var controlClass: String? {
            switch self {
            case .small: return "form-control-sm"
            case .large: return "form-control-lg"
            case .medium: return nil
            }
        }

        var labelClass: String? {
            switch self {
            case .small: return "col-form-label-sm"
            case .large: return "col-form-label-lg"
            case .medium: return nil
            }
        }

        var buttonClass: String? {
            switch self {
            case .small: return "btn-sm"
            case .large: return "btn-lg"
            case .medium: return nil
            }
        }
    }

    /// Sets the style for form labels
    /// - Parameter style: How labels should be displayed
    /// - Returns: A modified form with the specified label style
    public func labelStyle(_ style: LabelStyle) -> Self {
        var copy = self
        copy.labelStyle = style
        return copy
    }

    /// Sets the size of form controls and labels
    /// - Parameter size: The desired size
    /// - Returns: A modified form with the specified control size
    public func controlSize(_ size: FormControlSize) -> Self {
        var copy = self
        copy.controlSize = size
        return copy
    }

    /// Adjusts the number of columns that can be fitted into this section.
    /// - Parameter columns: The number of columns to use
    /// - Returns: A new `Section` instance with the updated column count.
    public func columns(_ columns: Int) -> Self {
        var copy = self
        copy.columnCount = columns
        return copy
    }

    /// Creates a new form with the specified spacing and content.
    /// - Parameters:
    ///   - horizontalSpacing: The amount of horizontal space between elements. Defaults to `.medium`.
    ///   - verticalSpacing: The amount of vertical space between elements. Defaults to `.medium`.
    ///   - content: A closure that returns the form's elements.
    ///   - onSubmit: A closure that takes the form's ID as a parameter and returns the action to perform when the form is submitted.
    public init(
        horizontalSpacing: SpacingAmount = .medium,
        verticalSpacing: SpacingAmount = .medium,
        @InlineHTMLBuilder content: () -> some InlineHTML,
        onSubmit: @escaping (String) -> any Action
    ) {
        self.items = flatUnwrap(content())
        self.action = onSubmit
        self.verticalSpacing = verticalSpacing
        self.horizontalSpacing = horizontalSpacing
        if attributes.id.isEmpty {
            attributes.id = UUID().uuidString.truncatedHash
        }
    }

    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = "form"
        let action = action(attributes.id)

        if let action = action as? SubscribeAction {
            attributes.customAttributes.insert(.init(name: "method", value: "post"))
            attributes.customAttributes.insert(.init(name: "action", value: action.endpoint))
        }

        let wrappedContent = Group {
            Group {
                ForEach(items) { item in
                    if let textField = item as? TextField, let labelText = textField.label {
                        if labelStyle == .hidden {
                            Group(textField.class(controlSize.controlClass))
                                .class(getColumnClass(for: item, totalColumns: columnCount))
                        } else if labelStyle == .floating {
                            Group {
                                Group {
                                    textField
                                        .class(controlSize.controlClass)
                                    Label(text: labelText)
                                        .class(controlSize.labelClass)
                                        .customAttribute(name: "for", value: textField.attributes.id)
                                }
                                .class("form-floating")
                            }
                            .class(getColumnClass(for: item, totalColumns: columnCount))
                        } else {
                            Group {
                                Label(text: labelText)
                                    .class(labelStyle == .left ? "col-form-label col-sm-2" : "form-label")
                                    .class(controlSize.labelClass)
                                    .customAttribute(name: "for", value: textField.attributes.id)

                                if labelStyle == .left {
                                    Group {
                                        textField
                                            .class(controlSize.controlClass)
                                    }
                                    .class("col-sm-10")
                                } else {
                                    textField
                                        .class(controlSize.controlClass)
                                }
                            }
                            .class(getColumnClass(for: item, totalColumns: columnCount))
                            .class(labelStyle == .left ? "row" : "")
                        }
                    } else if let button = item as? Button {
                        Group(button.class(controlSize.buttonClass))
                            .class(getColumnClass(for: item, totalColumns: columnCount))
                            .class("d-flex", "align-items-stretch")
                    } else {
                        Group(item)
                            .class(getColumnClass(for: item, totalColumns: columnCount))
                    }
                }
            }
            .class(
                "row",
                "g-\(horizontalSpacing.rawValue)",
                "gy-\(verticalSpacing.rawValue)"
            )
            .class(labelStyle == .floating ? "align-items-stretch" : "align-items-end")
        }
        .render(context: context)

        var output = wrappedContent
        output += Script(code: action.compile()).render(context: context)

        return attributes.description(wrapping: output)
    }

    /// Calculates the appropriate Bootstrap column class for an HTML element.
    /// - Parameters:
    ///   - item: The HTML element to calculate the column class for.
    ///   - totalColumns: The total number of columns in the form's grid.
    /// - Returns: A string containing the appropriate Bootstrap column class.
    private func getColumnClass(for item: any HTML, totalColumns: Int) -> String {
        if let item = item as? (any BlockHTML),
           case .count(let width) = item.columnWidth {
            // Convert the width from form columns to Bootstrap columns
            let bootstrapColumns = 12 * width / totalColumns
            return "col-md-\(bootstrapColumns)"
        } else {
            // Default to one column width if not specified
            return "col-md-\(12 / totalColumns)"
        }
    }
}

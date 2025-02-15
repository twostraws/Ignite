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
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    /// How many columns this should be divided into
    private var columnCount: Int = 12

    /// The amount of vertical spacing between form elements.
    private var verticalSpacing: SpacingAmount

    /// The amount of horizontal spacing between form elements.
    private var horizontalSpacing: SpacingAmount

    /// The form elements to be rendered.
    private var items: [any InlineElement]

    /// The action to perform when the form is submitted.
    private var action: any Action

    /// The style of labels in the form
    private var labelStyle: LabelStyle = .floating

    /// The size of form controls and labels
    private var controlSize: FormControlSize = .medium

    /// Controls how form labels are displayed
    public enum LabelStyle: CaseIterable, Sendable {
        /// Labels appear above their fields
        case top
        /// Labels appear to the left of their fields
        case front
        /// Labels float when the field has content
        case floating
        /// No labels are shown
        case hidden
    }

    /// Controls the size of form controls and labels
    public enum FormControlSize: CaseIterable, Sendable {
        case small
        case medium
        case large

        var controlClass: String? {
            switch self {
            case .small: "form-control-sm"
            case .large: "form-control-lg"
            case .medium: nil
            }
        }

        var labelClass: String? {
            switch self {
            case .small: "col-form-label-sm"
            case .large: "col-form-label-lg"
            case .medium: nil
            }
        }

        var buttonClass: String? {
            switch self {
            case .small: "btn-sm"
            case .large: "btn-lg"
            case .medium: nil
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
    ///   - onSubmit: A closure that takes the form's ID as a parameter and returns
    ///   the action to perform when the form is submitted.
    public init(
        horizontalSpacing: SpacingAmount = .medium,
        verticalSpacing: SpacingAmount = .medium,
        @InlineHTMLBuilder content: () -> some InlineElement,
        onSubmit: () -> any Action
    ) {
        self.items = flatUnwrap(content())
        self.action = onSubmit()
        self.verticalSpacing = verticalSpacing
        self.horizontalSpacing = horizontalSpacing
        if let action = action as? SubscribeAction, case .mailchimp = action.service {
            attributes.id = "mc-embedded-subscribe-form"
        } else {
            attributes.id = UUID().uuidString.truncatedHash
        }
    }

    public func render() -> String {
        guard var action = action as? SubscribeAction else {
            fatalError("Form supports only SubscribeAction at this time.")
        }

        action = action.setFormID(attributes.id)

        var attributes = attributes
        attributes.tag = "form"

        attributes.customAttributes.append(.init(name: "method", value: "post"))
        attributes.customAttributes.append(.init(name: "action", value: action.service.endpoint(formID: action.formID)))
        attributes.data.formUnion(action.service.dataAttributes)

        if let formClass = action.service.formClass {
            attributes.classes.append(formClass)
        }

        if case .mailchimp = action.service {
            attributes.customAttributes.append(.init(name: "target", value: "_blank"))
        }

        let wrappedContent = Section {
            ForEach(items) { item in
                if let textField = item as? TextField {
                    renderFormField(textField)
                } else if let button = item as? Button {
                    renderButton(button)
                } else {
                    renderSimpleItem(item)
                }
            }

            if let honeypotName = action.service.honeypotFieldName {
                Section {
                    TextField(placeholder: nil)
                        .type(.text)
                        .customAttribute(name: "name", value: honeypotName)
                        .customAttribute(name: "tabindex", value: "-1")
                        .customAttribute(name: "value", value: "")
                        .customAttribute(name: "autocomplete", value: "off")
                }
                .customAttribute(name: "style", value: "position: absolute; left: -5000px;")
                .customAttribute(name: "aria-hidden", value: "true")
            }
        }
        .class("row", "g-\(horizontalSpacing.rawValue)", "gy-\(verticalSpacing.rawValue)")
        .class(labelStyle == .floating ? "align-items-stretch" : "align-items-end")
        .render()

        var formOutput = attributes.description(wrapping: wrappedContent)

        // Add custom SendFox JavaScript if needed.
        if case .sendFox = action.service {
            formOutput += Script(file: "https://cdn.sendfox.com/js/form.js")
                .customAttribute(name: "charset", value: "utf-8")
                .render()
        }

        return formOutput
    }

    private func renderFormField(_ textField: TextField) -> Section {
        guard var action = action as? SubscribeAction else {
            fatalError("Form supports only SubscribeAction at the moment.")
        }

        action = action.setFormID(attributes.id)

        let sizedTextField = textField
            .id(action.service.emailFieldID)
            .class(controlSize.controlClass)
            .customAttribute(name: "name", value: action.service.emailFieldName!)

        // If no label text, return just the field
        guard let textLabel = textField.label else {
            return renderSimpleItem(sizedTextField)
        }

        let label = Label(text: textLabel)
            .class(controlSize.labelClass)
            .customAttribute(name: "for", value: textField.attributes.id)

        return switch labelStyle {
        case .hidden:
            renderSimpleItem(sizedTextField)

        case .floating:
            Section {
                sizedTextField
                label
            }
            .class("form-floating")
            .containerClass(getColumnClass(for: textField, totalColumns: columnCount))

        case .front:
            Section {
                label.class("col-form-label col-sm-2")
                Section(sizedTextField).class("col-sm-10")
            }
            .class("row")
            .containerClass(getColumnClass(for: textField, totalColumns: columnCount))

        case .top:
            Section {
                label.class("form-label")
                sizedTextField
            }
            .class(getColumnClass(for: textField, totalColumns: columnCount))
        }
    }

    private func renderButton(_ button: Button) -> Section {
        Section(button.class(controlSize.buttonClass))
            .class(getColumnClass(for: button, totalColumns: columnCount))
            .class("d-flex", "align-items-stretch")
    }

    private func renderSimpleItem(_ item: any InlineElement) -> Section {
        Section(item)
            .class(getColumnClass(for: item, totalColumns: columnCount))
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
            // Default to auto width if not specified
            return "col"
        }
    }
}

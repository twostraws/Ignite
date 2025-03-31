//
// Form.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form container for collecting user input
public struct Form: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should be divided into
    private var columnCount: Int = 12

    /// The amount of vertical spacing between form elements.
    private var verticalSpacing: SpacingAmount

    /// The amount of horizontal spacing between form elements.
    private var horizontalSpacing: SpacingAmount

    /// The form elements to be rendered.
    private var items: HTMLCollection

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
        @InlineElementBuilder content: () -> some InlineElement,
        onSubmit: () -> any Action
    ) {
        self.items = HTMLCollection(content)
        self.action = onSubmit()
        self.verticalSpacing = verticalSpacing
        self.horizontalSpacing = horizontalSpacing
        if let action = action as? SubscribeAction, case .mailchimp = action.service {
            attributes.id = "mc-embedded-subscribe-form"
        } else {
            attributes.id = UUID().uuidString.truncatedHash
        }
    }

    @HTMLBuilder
    func formContent(for action: SubscribeAction) -> some HTML {
        Section {
            ForEach(items) { item in
                if let textField = item as? TextField {
                    formField(textField: textField, action: action)
                } else if let button = item as? Button {
                    styledButton(button)
                } else {
                    simpleItem(item)
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
    }

    public func render() -> String {
        guard let action = action as? SubscribeAction else {
            fatalError("Form supports only SubscribeAction at this time.")
        }

        var attributes = attributes

        attributes.append(customAttributes: .init(name: "method", value: "post"))
        attributes.append(customAttributes: .init(name: "target", value: "_blank"))
        attributes.append(customAttributes: .init(name: "action", value: action.service.endpoint))
        attributes.data.formUnion(action.service.dataAttributes)
        attributes.customAttributes.formUnion(action.service.customAttributes)

        if let formClass = action.service.formClass {
            attributes.append(classes: formClass)
        }

        if case .sendFox(_, let formID) = action.service {
            attributes.id = formID
        }

        let formContent = formContent(for: action)

        var formOutput = "<form\(attributes)>\(formContent)</form>"

        // Add custom SendFox JavaScript if needed.
        if case .sendFox = action.service {
            formOutput += Script(file: URL(static: "https://cdn.sendfox.com/js/form.js"))
                .customAttribute(name: "charset", value: "utf-8")
                .render()
        }

        return formOutput
    }

    @HTMLBuilder
    func labeledTextField(label: some InlineElement, field: some InlineElement) -> some HTML {
        switch labelStyle {
        case .hidden:
            simpleItem(field)

        case .floating:
            Section {
                Section {
                    field
                    label
                }
                .class("form-floating")
            }
            .class(getColumnClass(for: field, totalColumns: columnCount))

        case .front:
            Section {
                Section {
                    label.class("col-form-label col-sm-2")
                    Section(field).class("col-sm-10")
                }
                .class("row")
            }
            .class(getColumnClass(for: field, totalColumns: columnCount))

        case .top:
            Section {
                label.class("form-label")
                field
            }
            .class(getColumnClass(for: field, totalColumns: columnCount))
        }
    }

    @HTMLBuilder
    private func formField(textField: TextField, action: SubscribeAction) -> some HTML {
        let sizedTextField = textField
            .id(action.service.emailFieldID)
            .class(controlSize.controlClass)
            .customAttribute(name: "name", value: action.service.emailFieldName!)

        // If no label text, return just the field
        if let textLabel = textField.label {
            let label = FormFieldLabel(text: textLabel)
                .class(controlSize.labelClass)
                .customAttribute(name: "for", value: action.service.emailFieldID)

            labeledTextField(label: label, field: sizedTextField)
        } else {
            simpleItem(sizedTextField)
        }
    }

    private func styledButton(_ button: Button) -> some HTML {
        Section(button.class(controlSize.buttonClass))
            .class(getColumnClass(for: button, totalColumns: columnCount))
            .class("d-flex", "align-items-stretch")
    }

    private func simpleItem(_ item: any HTML) -> some HTML {
        Section(item)
            .class(getColumnClass(for: item, totalColumns: columnCount))
    }

    /// Calculates the appropriate Bootstrap column class for an HTML element.
    /// - Parameters:
    ///   - item: The HTML element to calculate the column class for.
    ///   - totalColumns: The total number of columns in the form's grid.
    /// - Returns: A string containing the appropriate Bootstrap column class.
    private func getColumnClass(for item: any HTML, totalColumns: Int) -> String {
        if let widthClass = item.attributes.classes.first(where: { $0.starts(with: "col-md-") }),
           let width = Int(widthClass.dropFirst("col-md-".count)) {
            let bootstrapColumns = 12 * width / totalColumns
            return "col-md-\(bootstrapColumns)"
        } else {
            return "col"
        }
    }
}

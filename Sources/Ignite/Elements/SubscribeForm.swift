//
// SubscribeForm.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form for collecting email addresses for newsletter subscriptions.
public struct SubscribeForm: HTML, NavigationItem {
    /// Defines how labels appear in the form.
    public enum LabelStyle: Sendable, CaseIterable {
        /// Labels are not visible but remain accessible to screen readers.
        case hidden
        /// Labels appear within the form field and animate when the field is focused.
        case floating
    }

    /// Defines the layout arrangement of form elements.
    public enum FormStyle: Sendable {
        /// Elements are arranged horizontally in a single row.
        case inline
        /// Elements are stacked vertically.
        case stacked
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should be divided into
    private var columnCount: Int = 12

    /// The amount of vertical spacing between form elements.
    private var spacing: SpacingAmount

    /// The size of form controls and labels
    private var controlSize: ControlSize = .medium

    /// The email platform that will receive form submissions.
    private let service: EmailPlatform

    /// The text displayed on the subscription button.
    private var subscribeButtonLabel = "Subscribe"

    /// The text color for the subscription button.
    private var subscribeButtonForegroundStyle: Color?

    /// The visual style of the subscription button.
    private var subscribeButtonRole: Role = .primary

    /// The label text for the email input field.
    private var emailFieldLabel = "Email"

    /// The display style for form labels.
    private var labelStyle: LabelStyle = .hidden

    /// The layout arrangement for form elements.
    private var formStyle: FormStyle = .inline

    /// Controls whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent `NavigationBar`.
    private var isNavigationItem = false

    /// Creates a new form with the specified spacing and content.
    /// - Parameters:
    ///   - spacing: The amount of horizontal space between elements. Defaults to `.medium`.
    ///   - content: A closure that returns the form's elements.
    ///   - onSubmit: A closure that takes the form's ID as a parameter and returns
    ///   the action to perform when the form is submitted.
    public init(
        _ service: EmailPlatform,
        spacing: SpacingAmount = .medium
    ) {
        self.spacing = spacing
        self.service = service

        attributes.append(customAttributes: .init(name: "method", value: "post"))
        attributes.append(customAttributes: .init(name: "target", value: "_blank"))
        attributes.append(customAttributes: .init(name: "action", value: service.endpoint))
        attributes.data.formUnion(service.dataAttributes)
        attributes.customAttributes.formUnion(service.customAttributes)
        attributes.append(classes: service.formClass)

        switch service {
        case .mailchimp:
            attributes.id = "mc-embedded-subscribe-form"
        case .sendFox(_, let formID):
            attributes.id = formID
        default:
            attributes.id = UUID().uuidString.truncatedHash
        }
    }

    /// Sets the text color of the subscribe button.
    /// - Parameter style: The color to apply to the button text.
    /// - Returns: A modified form with the specified button text color.
    public func subscribeButtonForegroundStyle(_ style: Color) -> Self {
        var copy = self
        copy.subscribeButtonForegroundStyle = style
        return copy
    }

    /// Sets the visual role of the subscribe button.
    /// - Parameter role: The role determining the button's appearance.
    /// - Returns: A modified form with the specified button role.
    public func subscribeButtonRole(_ role: Role) -> Self {
        var copy = self
        copy.subscribeButtonRole = role
        return copy
    }

    /// Sets the text displayed on the subscribe button.
    /// - Parameter label: The text to display on the button.
    /// - Returns: A modified form with the updated button text.
    public func subscribeButtonLabel(_ label: String) -> Self {
        var copy = self
        copy.subscribeButtonLabel = label
        return copy
    }

    /// Sets the label for the email input field.
    /// - Parameter label: The text to use as the email field label.
    /// - Returns: A modified form with the updated field label.
    public func emailFieldLabel(_ label: String) -> Self {
        var copy = self
        copy.emailFieldLabel = label
        return copy
    }

    /// Sets the size of form controls and labels
    /// - Parameter size: The desired size
    /// - Returns: A modified form with the specified control size
    public func controlSize(_ size: ControlSize) -> Self {
        var copy = self
        copy.controlSize = size
        return copy
    }

    /// Sets how labels are displayed within the form.
    /// - Parameter style: The style determining how labels appear.
    /// - Returns: A modified form with the specified label style.
    public func labelStyle(_ style: LabelStyle) -> Self {
        var copy = self
        copy.labelStyle = style
        return copy
    }

    /// Sets the arrangement of form elements.
    /// - Parameter style: The layout style to apply to the form.
    /// - Returns: A modified form with the specified layout style.
    public func formStyle(_ style: FormStyle) -> Self {
        var copy = self
        copy.formStyle = style
        return copy
    }

    /// Configures this dropdown to be placed inside a `NavigationBar`.
    /// - Returns: A new `Form` instance suitable for placement
    /// inside a `NavigationBar`.
    func configuredAsNavigationItem() -> Self {
        var copy = self
        copy.isNavigationItem = true
        return copy
    }

    public func markup() -> Markup {
        var formOutput = Form {
            TextField(emailFieldLabel, prompt: emailFieldLabel)
                .type(.text)
                .id(service.emailFieldID)
                .class(controlSize.controlClass)
                .customAttribute(name: "name", value: service.emailFieldName!)
                .class(formStyle == .inline ? "col" : "col-md-12")

            Button(subscribeButtonLabel)
                .type(.submit)
                .role(subscribeButtonRole)
                .style(.color, subscribeButtonForegroundStyle != nil ? subscribeButtonForegroundStyle!.description : "")
                .class(controlSize.buttonClass)
                .class(formStyle == .inline ? nil : "w-100")
                .class(formStyle == .inline ? "col-auto" : "col")

            if let honeypotName = service.honeypotFieldName {
                Section {
                    TextField(EmptyInlineElement(), prompt: nil)
                        .id("")
                        .labelStyle(.hidden)
                        .customAttribute(name: "name", value: honeypotName)
                        .customAttribute(name: "tabindex", value: "-1")
                        .customAttribute(name: "value", value: "")
                        .customAttribute(name: "autocomplete", value: "off")
                }
                .customAttribute(name: "style", value: "position: absolute; left: -5000px;")
                .customAttribute(name: "aria-hidden", value: "true")
            }
        }
        .configuredAsNavigationItem(isNavigationItem)
        .labelStyle(labelStyle == .floating ? .floating : .hidden)
        .attributes(attributes)
        .markup()

        if let script = service.script {
            formOutput += Script(file: URL(static: script))
                .customAttribute(name: "charset", value: "utf-8")
                .markup()
        }

        return formOutput
    }
}

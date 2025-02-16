//
// SubscribeAction.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents a form submission action for newsletter subscriptions
public struct SubscribeAction: Action {
    /// Represents different newsletter service providers
    public enum EmailPlatform: Sendable {
        /// Mailchimp newsletter integration
        case mailchimp(username: String, uValue: String, listID: String)
        /// SendFox newsletter integration
        case sendFox(String)
        /// Kit (ConvertKit) newsletter integration
        case kit(String)
        /// Buttondown newsletter integration
        case buttondown(String)

        func endpoint(formID: String) -> String {
            switch self {
            case .mailchimp(let username, let uValue, let listID):
                "https://\(username).us1.list-manage.com/subscribe/post?u=\(uValue)&id=\(listID)"
            case .kit(let token):
                "https://app.convertkit.com/forms/\(token)/subscriptions"
            case .sendFox(let listID):
                "https://sendfox.com/form/\(listID)/\(formID)"
            case .buttondown(let token):
                "https://buttondown.email/api/emails/embed-subscribe/\(token)"
            }
        }

        var customAttributes: [Attribute] {
            switch self {
            case .mailchimp:
                [.init(name: "method", value: "post"),
                 .init(name: "name", value: "mc-embedded-subscribe-form"),
                 .init(name: "target", value: "_blank")]
            default:
                [.init(name: "method", value: "post")]
            }
        }

        var dataAttributes: [Attribute] {
            switch self {
            case .sendFox:
                [.init(name: "async", value: "true"),
                 .init(name: "recaptcha", value: "true")]
            default: []
            }
        }

        var formClass: String? {
            switch self {
            case .mailchimp:
                "validate"
            case .sendFox:
                "sendfox-form"
            default:
                nil
            }
        }

        var emailFieldID: String {
            switch self {
            case .mailchimp:
                "mce-EMAIL"
            case .sendFox:
                "sendfox_form_email"
            default:
                ""
            }
        }

        var emailFieldName: String? {
            switch self {
            case .sendFox, .buttondown:
                "email"
            case .mailchimp:
                "EMAIL"
            case .kit:
                "email_address"
            }
        }

        var honeypotFieldName: String? {
            switch self {
            case .mailchimp(_, let uValue, let listId):
                "b_\(uValue)_\(listId)"
            case .sendFox:
                "a_password"
            default:
                nil
            }
        }
    }

    /// The email platform to use
    let service: EmailPlatform

    /// The ID of the form this action is attached to
    var formID: String

    /// Sets the form identifier for this subscription action.
    /// - Parameter formID: A string that uniquely identifies the form in the newsletter service.
    /// - Returns: A new `SubscribeAction` instance with the updated form identifier.
    func setFormID(_ formID: String) -> Self {
        var copy = self
        copy.formID = formID
        return copy
    }

    /// Creates a new subscribe action for a specific form.
    /// - Parameters:
    ///   - service: The email service to use for subscription.
    public init(_ service: EmailPlatform) {
        self.service = service
        self.formID = ""
    }

    /// Renders this action using publishing context passed in.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        ""
    }
}

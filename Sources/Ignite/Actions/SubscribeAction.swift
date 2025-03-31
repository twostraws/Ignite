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
        case sendFox(listID: String, formID: String)
        /// Kit (ConvertKit) newsletter integration
        case kit(String)
        /// Buttondown newsletter integration
        case buttondown(String)

        var endpoint: String {
            switch self {
            case .mailchimp(let username, let uValue, let listID):
                "https://\(username).us1.list-manage.com/subscribe/post?u=\(uValue)&id=\(listID)"
            case .kit(let token):
                "https://app.convertkit.com/forms/\(token)/subscriptions"
            case .sendFox(let listID, let formID):
                "https://sendfox.com/form/\(listID)/\(formID)"
            case .buttondown(let username):
                "https://buttondown.com/api/emails/embed-subscribe/\(username)"
            }
        }

        var customAttributes: [Attribute] {
            switch self {
            case .mailchimp:
                [.init(name: "name", value: "mc-embedded-subscribe-form")]
            default:
                []
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
            case .buttondown:
                "embeddable-buttondown-form"
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
            case .buttondown:
                "bd-email"
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
            case .mailchimp(_, let uValue, let listID):
                "b_\(uValue)_\(listID)"
            case .sendFox:
                "a_password"
            default:
                nil
            }
        }
    }

    /// The email platform to use
    let service: EmailPlatform

    /// Creates a new subscribe action for a specific form.
    /// - Parameters:
    ///   - service: The email service to use for subscription.
    public init(_ service: EmailPlatform) {
        self.service = service
    }

    /// Renders this action using publishing context passed in.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        ""
    }
}

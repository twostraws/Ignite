//
// SubscribeAction.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents a form submission action for newsletter subscriptions
public struct SubscribeAction: Action {
    /// The email platform to use
    let service: EmailPlatform

    /// The ID of the form this action is attached to
    private var formID: String

    /// Represents different newsletter service providers
    public enum EmailPlatform: Sendable {
        /// Mailchimp newsletter integration
        case mailchimp(String)
        /// Kit (ConvertKit) newsletter integration
        case kit(String)
        /// Substack newsletter integration
        case substack(String)
        /// SendFox newsletter integration
        case sendFox(String)
        /// Buttondown newsletter integration
        case buttondown(String)
        /// Custom form endpoint
        case custom(String)

        var endpoint: String {
            switch self {
            case .mailchimp(let token):
                "https://\(token).list-manage.com/subscribe/post"
            case .kit(let token):
                "https://app.convertkit.com/forms/\(token)/subscriptions"
            case .substack(let token):
                "https://\(token).substack.com/api/v1/free"
            case .sendFox(let token):
                "https://sendfox.com/api/subscribers/\(token)"
            case .buttondown(let token):
                "https://buttondown.email/api/emails/embed-subscribe/\(token)"
            case .custom(let url):
                url
            }
        }
    }

    /// Creates a new subscribe action
    /// - Parameters:
    ///   - service: The newsletter service to use
    ///   - formID: The ID of the form this action is attached to
    public init(_ service: EmailPlatform, formID: String) {
        self.service = service
        self.formID = formID
    }

    /// The endpoint URL for the form submission
    var endpoint: String {
        service.endpoint
    }

    /// Returns the JavaScript needed for form handling
    public func compile() -> String {
        """
        document.getElementById('\(formID)').addEventListener('submit', function() {
            setTimeout(function() {
                document.getElementById('\(formID)').reset();
            }, 100);
        });
        """
    }
}


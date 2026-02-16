//
// SubscribeForm.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Testing
@testable import Ignite

/// Tests for the `SubscribeForm` element.
@Suite("Subscribe Form Tests")
@MainActor
class SubscribeFormTests: IgniteTestSuite {
    @Test("Basic Subscribe Form")
    func form() async throws {
        let element = SubscribeForm(.sendFox(listID: "myListID", formID: "myID"))
            .emailFieldLabel("MyLabel")
            .labelStyle(.floating)

        let output = element.markupString()

        #expect(output == """
        <form id="myID" method="post" target="_blank" action="https://sendfox.com/form/myListID/myID" \
        class="sendfox-form row g-3" data-async data-recaptcha="true">\
        <div class="col">\
        <div class="form-floating">\
        <input id="sendfox_form_email" placeholder="MyLabel" \
        type="text" name="email" class="form-control col" />\
        <label for="sendfox_form_email">MyLabel</label>\
        </div>\
        </div>\
        <div class="col-auto d-flex align-items-stretch">\
        <button type="submit" class="col-auto w-100 btn btn-primary">Subscribe</button>\
        </div>\
        <fieldset style="position: absolute; left: -5000px;" aria-hidden="true">\
        <div class="form-floating">\
        <input type="text" name="a_password" tabindex="-1" value="" autocomplete="off" \
        class="form-control" />\
        </div>\
        </fieldset>\
        </form>\
        <script charset="utf-8" src="https://cdn.sendfox.com/js/form.js"></script>
        """)
    }

    @Test("Mailchimp form uses correct endpoint and form ID")
    func mailchimpForm() async throws {
        let element = SubscribeForm(.mailchimp(username: "user", uValue: "abc", listID: "123"))
        let output = element.markupString()
        #expect(output.contains("action=\"https://user.us1.list-manage.com/subscribe/post?u=abc&id=123\""))
        #expect(output.contains("id=\"mc-embedded-subscribe-form\""))
        #expect(output.contains("name=\"mc-embedded-subscribe-form\""))
    }

    @Test("Kit form uses correct endpoint and email field name")
    func kitForm() async throws {
        let element = SubscribeForm(.kit("myToken"))
        let output = element.markupString()
        #expect(output.contains("action=\"https://app.convertkit.com/forms/myToken/subscriptions\""))
        #expect(output.contains("name=\"email_address\""))
    }

    @Test("Buttondown form uses correct endpoint and form class")
    func buttondownForm() async throws {
        let element = SubscribeForm(.buttondown("myuser"))
        let output = element.markupString()
        #expect(output.contains("action=\"https://buttondown.com/api/emails/embed-subscribe/myuser\""))
        #expect(output.contains("embeddable-buttondown-form"))
    }

    @Test("Custom subscribe button label renders correctly")
    func customButtonLabel() async throws {
        let element = SubscribeForm(.sendFox(listID: "x", formID: "y"))
            .subscribeButtonLabel("Join Now")
        let output = element.markupString()
        #expect(output.contains(">Join Now</button>"))
    }

    // MARK: - Form style

    @Test("Stacked form style changes layout to vertical")
    func stackedFormStyle() async throws {
        let element = SubscribeForm(.sendFox(listID: "x", formID: "y"))
            .formStyle(.stacked)
        let output = element.markupString()
        #expect(output.contains("col-md-12"))
        #expect(output.contains("w-100"))
    }

    // MARK: - Control size

    @Test("Small control size adds small classes")
    func smallControlSize() async throws {
        let element = SubscribeForm(.sendFox(listID: "x", formID: "y"))
            .controlSize(.small)
        let output = element.markupString()
        #expect(output.contains("form-control-sm"))
        #expect(output.contains("btn-sm"))
    }

    @Test("Large control size adds large classes")
    func largeControlSize() async throws {
        let element = SubscribeForm(.sendFox(listID: "x", formID: "y"))
            .controlSize(.large)
        let output = element.markupString()
        #expect(output.contains("form-control-lg"))
        #expect(output.contains("btn-lg"))
    }

    // MARK: - Button customization

    @Test("Custom button role changes button class")
    func customButtonRole() async throws {
        let element = SubscribeForm(.sendFox(listID: "x", formID: "y"))
            .subscribeButtonRole(.danger)
        let output = element.markupString()
        #expect(output.contains("btn-danger"))
        #expect(!output.contains("btn-primary"))
    }

    // MARK: - Provider-specific behavior

    @Test("Mailchimp form includes honeypot field with correct name")
    func mailchimpHoneypot() async throws {
        let element = SubscribeForm(.mailchimp(username: "user", uValue: "abc", listID: "123"))
        let output = element.markupString()
        #expect(output.contains("name=\"b_abc_123\""))
        #expect(output.contains("aria-hidden=\"true\""))
    }

    @Test("Kit form has no honeypot field and no external script")
    func kitNoHoneypotNoScript() async throws {
        let element = SubscribeForm(.kit("myToken"))
        let output = element.markupString()
        #expect(!output.contains("aria-hidden"))
        #expect(!output.contains("<script"))
    }
}

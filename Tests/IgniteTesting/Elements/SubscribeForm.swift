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
}

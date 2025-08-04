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
        type="text" name="email" class="form-control" />\
        <label for="sendfox_form_email">MyLabel</label>\
        </div>\
        </div>\
        <div class="col-auto">\
        <button type="submit" class="h-100 btn btn-primary">Subscribe</button>\
        </div>\
        <div style="position: absolute; left: -5000px;" aria-hidden="true">\
        <input type="text" name="a_password" tabindex="-1" value="" autocomplete="off" \
        class="form-control" />\
        </div>\
        </form>\
        <script charset="utf-8" src="https://cdn.sendfox.com/js/form.js"></script>
        """)
    }
}

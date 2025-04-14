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

        let output = element.render()

        #expect(output == """
        <form id="myID" method="post" target="_blank" action="https://sendfox.com/form/myListID/myID" \
        class="sendfox-form" data-async data-recaptcha="true">\
        <div class="row g-3">\
        <div class="col">\
        <div class="form-floating">\
        <input id="sendfox_form_email" placeholder="MyLabel" \
        type="text" name="email" class="form-control" />\
        <label for="sendfox_form_email">MyLabel</label>\
        </div>\
        </div>\
        <div class="col-auto d-flex align-items-stretch">\
        <button type="submit" class="btn btn-primary">Subscribe</button>\
        </div>\
        <div style="position: absolute; left: -5000px;" aria-hidden="true">\
        <input type="text" name="a_password" tabindex="-1" value="" autocomplete="off" \
        class="form-control" />\
        </div>\
        </div>\
        </form>\
        <script charset="utf-8" src="https://cdn.sendfox.com/js/form.js"></script>
        """)
    }
}

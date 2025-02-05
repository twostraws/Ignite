//
//  Form.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Form` element.
@Suite("Form Tests")
@MainActor
struct FormTests {
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("Basic Form")
    func form() async throws {
        let element = Form {
            TextField("MyLabel", placeholder: "MyPlaceholder")
            Button("Submit").type(.submit)
        } onSubmit: {
            SubscribeAction(.sendFox("myListID"))
        }
        .id("myID")

        let output = element.render()

        #expect(
            output == """
            <form id="myID" action="https://sendfox.com/form/myListID/myID" \
            method="post" class="sendfox-form" data-async="true" data-recaptcha="true">\
            <div class="align-items-stretch g-3 gy-3 row"><div class="col">\
            <div class="form-floating"><input id="sendfox_form_email" name="email" \
            placeholder="MyPlaceholder" type="text" class="form-control" />\
            <label for="sendfox_form_email">MyLabel</label>\
            </div>\
            </div>\
            <div class="align-items-stretch col d-flex">\
            <button type="submit" class="btn">Submit</button>\
            </div>\
            <div aria-hidden="true" style="position: absolute; left: -5000px;">\
            <input autocomplete="off" name="a_password" tabindex="-1" type="text" \
            value="" class="form-control" />\
            </div>\
            </div>\
            </form>\
            <script charset="utf-8" src="https://cdn.sendfox.com/js/form.js"></script>
            """)
    }

    // swiftlint:disable function_body_length
    @Test("Form with Label Style", arguments: Form.LabelStyle.allCases)
    func form_withLabelStyle(style: Form.LabelStyle) async throws {
        let element = Form {
            TextField("MyLabel", placeholder: "MyPlaceholder")
            Button("Submit").type(.submit)
        } onSubmit: {
            SubscribeAction(.sendFox("myListID"))
        }
        .id("myID")
        .labelStyle(style)

        let output = element.render()

        let alignClass = style == .floating ? "align-items-stretch" : "align-items-end"
        let formContent = switch style {
        case .front:
            """
            <div class="row">\
            <label for="sendfox_form_email" class="col-form-label col-sm-2">MyLabel</label>\
            <div class="col-sm-10">\
            <input id="sendfox_form_email" name="email" \
            placeholder="MyPlaceholder" type="text" class="form-control" />\
            </div>\
            </div>
            """
        case .floating:
            """
            <div class="form-floating">\
            <input id="sendfox_form_email" name="email" \
            placeholder="MyPlaceholder" type="text" class="form-control" />\
            <label for="sendfox_form_email">MyLabel</label>\
            </div>
            """
        case .top:
            """
            <label for="sendfox_form_email" class="form-label">MyLabel</label>\
            <input id="sendfox_form_email" name="email" \
            placeholder="MyPlaceholder" type="text" class="form-control" />
            """
        case .hidden:
            """
            <input id="sendfox_form_email" name="email" \
            placeholder="MyPlaceholder" type="text" class="form-control" />
            """
        }

        #expect(output == """
        <form id="myID" action="https://sendfox.com/form/myListID/myID" \
        method="post" class="sendfox-form" data-async="true" data-recaptcha="true">\
        <div class="\(alignClass) g-3 gy-3 row">\
        <div class="col">\(formContent)</div>\
        <div class="align-items-stretch col d-flex">\
        <button type="submit" class="btn">Submit</button></div>\
        <div aria-hidden="true" style="position: absolute; left: -5000px;">\
        <input autocomplete="off" name="a_password" tabindex="-1" \
        type="text" value="" class="form-control" />\
        </div>\
        </div>\
        </form>\
        <script charset="utf-8" src="https://cdn.sendfox.com/js/form.js"></script>
        """)
    }
    // swiftlint:enable function_body_length

    @Test("Form with Control Size", arguments: Form.FormControlSize.allCases)
    func form_withControlSize(controlSize: Form.FormControlSize) async throws {
        let element = Form {
            TextField("MyLabel", placeholder: "MyPlaceholder")
            Button("Submit").type(.submit)
        } onSubmit: {
            SubscribeAction(.sendFox("myID"))
        }
        .id("myID")
        .controlSize(controlSize)

        let output = element.render()

        #expect(output == """
        <form id="myID" action="https://sendfox.com/form/myID/myID" \
        method="post" class="sendfox-form" data-async="true" data-recaptcha="true">\
        <div class="align-items-stretch g-3 gy-3 row">\
        <div class="col">\
        <div class="form-floating">\
        <input id="sendfox_form_email" name="email" placeholder="MyPlaceholder" type="text" \
        class="form-control\(controlSize.controlClass.map { " " + $0 } ?? "")" />\
        <label for="sendfox_form_email"\(controlSize.labelClass.map { " class=\"" + $0 + "\"" } ?? "")>MyLabel</label>\
        </div>\
        </div>\
        <div class="align-items-stretch col d-flex">\
        <button type="submit" class="btn\(controlSize.buttonClass.map { " " + $0 } ?? "")">Submit</button>\
        </div>\
        <div aria-hidden="true" style="position: absolute; left: -5000px;">\
        <input autocomplete="off" name="a_password" tabindex="-1" type="text" value="" class="form-control" />\
        </div>\
        </div>\
        </form>\
        <script charset="utf-8" src="https://cdn.sendfox.com/js/form.js"></script>
        """)
    }
}

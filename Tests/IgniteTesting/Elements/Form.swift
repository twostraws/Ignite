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
class FormTests: IgniteTestSuite {
    @Test("Basic Form")
    func form() async throws {
        let element = Form {
            TextField("MyLabel", prompt: "MyPlaceholder")
                .id("field")
            Button("Submit").type(.submit)
        }

        let output = element.markupString()

        #expect(output == """
        <form id="\(element.attributes.id)" class="row g-3">\
        <div>\
        <div class="form-floating">\
        <input id="field" type="text" placeholder="MyPlaceholder" class="form-control" />\
        <label for="field">MyLabel</label>\
        </div>\
        </div>\
        <div class="d-flex align-items-stretch">\
        <button type="submit" class="w-100 btn">Submit</button>\
        </div>\
        </form>
        """)
    }

    // swiftlint:disable function_body_length
    @Test("Form with Label Style", arguments: ControlLabelStyle.allCases)
    func form_withLabelStyle(style: ControlLabelStyle) async throws {
        let element = Form {
            TextField("MyLabel", prompt: "MyPlaceholder")
                .id("field")
            Button("Submit").type(.submit)
        }
        .labelStyle(style)

        let output = element.markupString()

        let expected = switch style {
        case .leading:
            """
            <form id="\(element.attributes.id)">\
            <div class="row">\
            <label for="field" class="col-form-label col-sm-2">MyLabel</label>\
            <div class="col-sm-10">\
            <input id="field" type="text" placeholder="MyPlaceholder" class="form-control mb-3" />\
            </div>\
            </div>\
            <div class="d-flex align-items-end">\
            <button type="submit" class="mb-3 btn">Submit</button>\
            </div>\
            </form>
            """
        case .floating:
            """
            <form id="\(element.attributes.id)" class="row g-3">\
            <div>\
            <div class="form-floating">\
            <input id="field" type="text" placeholder="MyPlaceholder" class="form-control" />\
            <label for="field">MyLabel</label>\
            </div>\
            </div>\
            <div class="d-flex align-items-stretch">\
            <button type="submit" class="w-100 btn">Submit</button>\
            </div>\
            </form>
            """
        case .top:
            """
            <form id="\(element.attributes.id)" class="row g-3">\
            <div>\
            <div>\
            <label for="field" class="form-label">MyLabel</label>\
            <input id="field" type="text" placeholder="MyPlaceholder" class="form-control" />\
            </div>\
            </div>\
            <div class="d-flex align-items-end">\
            <button type="submit" class="w-100 btn">Submit</button>\
            </div>\
            </form>
            """
        case .hidden:
            """
            <form id="\(element.attributes.id)" class="row g-3">\
            <div>\
            <input id="field" type="text" placeholder="MyPlaceholder" class="form-control" />\
            </div>\
            <div class="d-flex align-items-end">\
            <button type="submit" class="w-100 btn">Submit</button>\
            </div>\
            </form>
            """
        }

        #expect(output == expected)
    }
    // swiftlint:enable function_body_length

    @Test("Form with Control Size", arguments: ControlSize.allCases)
    func form_withControlSize(controlSize: ControlSize) async throws {
        let element = Form {
            TextField("MyLabel", prompt: "MyPlaceholder")
                .id("field")
            Button("Submit").type(.submit)
        }
        .controlSize(controlSize)

        let output = element.markupString()

        #expect(output == """
        <form id="\(element.attributes.id)" class="row g-3">\
        <div>\
        <div class="form-floating">\
        <input id="field" type="text" placeholder="MyPlaceholder" \
        class="form-control\(controlSize.controlClass.map { " " + $0 } ?? "")" />\
        <label for="field"\(controlSize.labelClass.map { " class=\"" + $0 + "\"" } ?? "")>MyLabel</label>\
        </div>\
        </div>\
        <div class="d-flex align-items-stretch">\
        <button type="submit" \
        class="\(controlSize.buttonClass.map { $0 + " " } ?? "")w-100 btn">Submit</button>\
        </div>\
        </form>
        """)
    }
}

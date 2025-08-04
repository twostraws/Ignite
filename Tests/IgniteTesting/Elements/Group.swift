//
//  Group.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Group` element.
@Suite("Group Tests")
@MainActor
class GroupTests: IgniteTestSuite {
    @Test("Group does not change HTML structure")
    func groupDoesNotAddAnyAdditionalHTML() async throws {
        let element: any HTML = Group {
            ControlLabel("Top Label")
            Text("Middle Text")
            Button("Bottom Button") {
                ShowAlert(message: "Bottom Button Tapped")
            }
        }

        let output = element.markupString()

        #expect(output == """
        <label>Top Label</label>\
        <p>Middle Text</p>\
        <button type="button" class="btn" onclick="alert('Bottom Button Tapped')">Bottom Button</button>
        """)
    }

    @Test("Adding attributes to all children")
    func groupAppliesCustomAttributesToAllChildren() async throws {
        let attributeName = "data-info"
        let attributeValue = "Ignite"
        let element = Group {
            ControlLabel("Top Label")
            Text("Middle Text")
            Button("Bottom Button") {
                ShowAlert(message: "Bottom Button Tapped")
            }
        }.customAttribute(name: attributeName, value: attributeValue)

        let output = element.markupString()

        #expect(output == """
        <label \(attributeName)="\(attributeValue)">Top Label</label>\
        <p \(attributeName)="\(attributeValue)">Middle Text</p>\
        <button type="button" \(attributeName)="\(attributeValue)" class="btn" \
        onclick="alert('Bottom Button Tapped')">Bottom Button</button>
        """)
    }
}

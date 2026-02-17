//
//  Item.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Item` element.
@Suite("Item Tests")
@MainActor
struct ItemTests {
    @Test("Basic accordian item test with default open mode .individual")
    func basicItemWithParentAccordianOpenModeIndividual() async throws {
        let accordianID = "accordion\(UUID().uuidString.truncatedHash)"
        let element = Item("First item") {
            Text("This is an accordion item.")
        }
        .assigned(to: accordianID, openMode: .individual)

        let output = element.markupString()

        // extract the itemID
        let startIndex = output.firstIndex(of: "#")!
        let itemIDStringRange =  output.index(after: startIndex)..<output.index(startIndex, offsetBy: 25)
        let itemID = output[itemIDStringRange]

        #expect(output == """
        <div class="accordion-item">\
        <h2 class="accordion-header">\
        <button type="button" class="accordion-button collapsed btn" data-bs-toggle="collapse" \
        data-bs-target="#\(itemID)" aria-expanded="false" aria-controls="\(itemID)">First item</button>\
        </h2>\
        <div id="\(itemID)" class="accordion-collapse collapse" data-bs-parent="#\(accordianID)">\
        <div class="accordion-body">\
        <p>This is an accordion item.</p>\
        </div></div></div>
        """)
    }

    @Test("Item with startsOpen true renders without collapsed class and with show class")
    func startsOpenTrue() async throws {
        let accordionID = "accordion\(UUID().uuidString.truncatedHash)"
        let element = Item("Open item", startsOpen: true) {
            Text("Visible content")
        }
        .assigned(to: accordionID, openMode: .individual)

        let output = element.markupString()
        #expect(output.contains("accordion-button "))
        #expect(!output.contains("accordion-button collapsed"))
        #expect(output.contains("aria-expanded=\"true\""))
        #expect(output.contains("collapse show"))
    }

    @Test("Item with contentBackground adds background style")
    func contentBackgroundColor() async throws {
        let accordionID = "accordion\(UUID().uuidString.truncatedHash)"
        let element = Item("Colored item") {
            Text("Content")
        }
        .contentBackground(.red)
        .assigned(to: accordionID, openMode: .individual)

        let output = element.markupString()
        #expect(output.contains("background:"))
    }

    @Test("Item with openMode all omits data-bs-parent with accordion ID")
    func openModeAll() async throws {
        let accordionID = "accordion\(UUID().uuidString.truncatedHash)"
        let element = Item("All mode") {
            Text("Content")
        }
        .assigned(to: accordionID, openMode: .all)

        let output = element.markupString()
        #expect(!output.contains("data-bs-parent=\"#\(accordionID)\""))
    }
}

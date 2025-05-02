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
}

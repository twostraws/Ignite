//
//  Accordion.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Accordion` element.
@Suite("Accordion Tests")
@MainActor
class AccordionTests: IgniteTestSuite {
    @Test("Renders a div tag of class accordion")
    func outputs_div_with_class_accordion() async throws {
        let sut = Accordion {}
        let attributes = try #require(sut.markupString().htmlTagWithCloseTag("div")?.attributes)
        let classAttribute = try #require(attributes.htmlAttribute(named: "class"))
        #expect(classAttribute == "accordion")
    }

    @Test("Provides a Unique id")
    func outputs_div_with_unique_id() async throws {
        let sut = Accordion {}

        let idattribute = try #require(sut.markupString().htmlTagWithCloseTag("div")?
            .attributes
            .htmlAttribute(named: "id")
        )

        let expected = /accordion[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]/
        #expect(idattribute.firstMatch(of: expected) != nil)
    }

    @Test("Outputs Items Provided", arguments: [AccordionOpenMode.all, .individual])
    func outputs_result_of_calling_render_on_each_item_provided(openMode: AccordionOpenMode) throws {
        @AccordionElementBuilder func items() -> some AccordionElement {
            Item("title 1", content: {})
            Item("second title", content: { Text("hello") })
            Item("titulo 3", content: { Image("imagename") })
        }

        let sut = Accordion(items).openMode(openMode)
        let output = sut.markupString()

        let accordionID = try #require(output.htmlTagWithCloseTag("div")?.attributes.htmlAttribute(named: "id"))

        // the item id will be unique
        // each time render() is called on each Item
        // so that part of the result will never match
        let deterministicOutput = output
            .clearingItemIDs()
            .clearingAccordionIDs()

        for item in items().subviews() {
            let itemoutput = item
                .assigned(to: accordionID, openMode: openMode)
                .markupString()

            let expected = itemoutput
                .clearingItemIDs()
                .clearingAccordionIDs()

            #expect(deterministicOutput.contains(expected))
        }
    }

    @Test("Items Receive Accordion ID of parent Accordion", arguments: [AccordionOpenMode.all, .individual])
    func provides_accordion_id_to_each_item_output(openMode: AccordionOpenMode) throws {
        @AccordionElementBuilder func items() -> some AccordionElement {
            Item("title 1", content: {})
            Item("second title", content: { Text("hello") })
            Item("titulo 3", content: { Image("imagename") })
        }

        let sut = Accordion(items).openMode(openMode)
        let output = sut.markupString()

        let accordionID = try #require(output.htmlTagWithCloseTag("div")?.attributes.htmlAttribute(named: "id"))

        let pattern = /accordion[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]/

        for match in output.matches(of: pattern) {
            #expect(String(match.0) == accordionID)
        }
    }
}

// MARK: - Helpers

private extension String {
    func clearingItemIDs() -> String {
        let toReplace = /item[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]/
        return replacing(toReplace, with: "-----")
    }

    func clearingAccordionIDs() -> String {
        let toReplace = /accordion[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]/
        return replacing(toReplace, with: "-----")
    }
}

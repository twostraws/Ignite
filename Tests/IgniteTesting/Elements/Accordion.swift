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
struct AccordionTests {
    
    @Test("Renders a div tag of class accordion")
    func outputs_div_with_class_accordion() async throws {
        let sut = Accordion {}

        let attributes = try #require(sut.render().htmlTagWithCloseTag("div")?.attributes)
        let classAttribute = try #require(attributes.htmlAttribute(named: "class"))
        
        #expect(classAttribute == "accordion")
    }
    
    @Test("Provides a Unique id")
    func outputs_div_with_unique_id() async throws {
        let sut = Accordion {}

        let idattribute = try #require(sut.render().htmlTagWithCloseTag("div")?
            .attributes
            .htmlAttribute(named: "id")
        )

        let expected = /accordion[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]/
        #expect(nil != idattribute.firstMatch(of: expected))
    }

    
    @Test("ExampleTest")
    func print_example() async throws {
        let sut = Accordion {}
            .openMode(.all)
        let output = sut.render()
        
        print(output)
    }
}

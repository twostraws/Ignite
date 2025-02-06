//
//  HTMLHead.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `HTMLHead` element.
@Suite("HTMLHead Tests")
@MainActor
struct HTMLHeadTests {
    
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("Defaults to empty head tag")
    func default_is_empty_head_tag() throws {
        let sut = HTMLHead {}
        let output = sut.render()
        
        let (attributes, contents) = try #require(output.htmlTagWithCloseTag("head"))
        
        #expect(contents.isEmpty)
        #expect(attributes.isEmpty)
    }

    @Test func outputs_items_passed_on_init() throws {
        func exampleHeaderItems() -> [any HeadElement] { [
            Title("Hello, World"),
            Script(file: "../script.js"),
            MetaTag(.openGraphTitle, content: "hello")
        ] }
        let sut = HTMLHead(items: exampleHeaderItems)
        
        let contents = try #require(sut.render().htmlTagWithCloseTag("head")?.contents)
        
        for item in exampleHeaderItems() {
            #expect(contents.contains(item.render()))
        }
    }
    
    @Test func print_head() {
        let sut = HTMLHead {
            
        }
        
        print(sut.render())
    }
}

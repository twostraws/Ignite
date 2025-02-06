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
    
    @Test("Defaults to empty head tag")
    func default_is_empty_head_tag() throws {
        let sut = HTMLHead {}
        let output = sut.render()
        
        let (attributes, contents) = try #require(output.htmlTagWithCloseTag("head"))
        
        #expect(contents.isEmpty)
        #expect(attributes.isEmpty)
    }
    
    @Test func print_head() {
        let sut = HTMLHead {
            
        }
        
        print(sut.render())
    }
}

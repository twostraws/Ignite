//
//  CodeBlock.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `CodeBlock` element.
@Suite("CodeBlock Tests")
@MainActor
class CodeBlockTests: IgniteTestSuite {
    @Test("Rendering a code block")
    func codeBlockTest() {
        let element = CodeBlock { """
        import Foundation
        struct CodeBlockTest {
            let name: String
        }
        let test = CodeBlockTest(name: "Swift")
        """ }

        let output = element.render()

        #expect(output == """
        <pre><code>import Foundation
        struct CodeBlockTest {
            let name: String
        }
        let test = CodeBlockTest(name: "Swift")</code></pre>
        """)
    }
}

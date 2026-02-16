//
// HTMLBody.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// A site configured to use remote Bootstrap CDN.
private struct RemoteBootstrapSite: Site {
    var name = "Test"
    var url = URL(static: "https://www.example.com")
    var homePage = TestPage()
    var layout = EmptyLayout()
    var useDefaultBootstrapURLs: BootstrapOptions = .remoteBootstrap
}

/// A site configured with visible line numbers.
private struct LineNumbersSite: Site {
    var name = "Test"
    var url = URL(static: "https://www.example.com")
    var homePage = TestPage()
    var layout = EmptyLayout()
    var syntaxHighlighterConfiguration: SyntaxHighlighterConfiguration

    init(lineNumberVisibility: SyntaxHighlighterConfiguration.LineNumberVisibility = .visible) {
        self.syntaxHighlighterConfiguration = SyntaxHighlighterConfiguration(
            languages: [],
            lineNumberVisibility: lineNumberVisibility
        )
    }
}

/// Tests for the `Body` element.
@Suite("Body Tests")
@MainActor class BodyTests: IgniteTestSuite {
    @Test("Simple Body Test")
    func simpleBody() async throws {
        let element = Body()
        let output = element.markupString()
        let path = publishingContext.path(for: URL(string: "/js")!)

        #expect(output == """
        <body class="container">\
        <script src="\(path)/bootstrap.bundle.min.js"></script>\
        <script src="\(path)/ignite-core.js"></script>\
        </body>
        """)
    }

    @Test("Body with content renders content inside body tags")
    func bodyWithContent() async throws {
        let element = Body { Text("Hello") }
        let output = element.markupString()
        #expect(output.contains("<body"))
        #expect(output.contains("Hello"))
        #expect(output.contains("</body>"))
    }

    @Test("Body without container omits container class")
    func bodyIgnorePageGutters() async throws {
        let element = Body().ignorePageGutters()
        let output = element.markupString()
        #expect(!output.contains("container"))
    }

    @Test("Body with data attribute renders data attribute")
    func bodyDataAttribute() async throws {
        let element = Body().data("theme", "dark")
        let output = element.markupString()
        #expect(output.contains("data-theme=\"dark\""))
    }

    // MARK: - Bootstrap branches

    @Test("Remote bootstrap includes CDN script with integrity and crossorigin")
    func remoteBootstrap() async throws {
        try PublishingContext.initialize(for: RemoteBootstrapSite(), from: #filePath)
        let element = Body()
        let output = element.markupString()
        #expect(output.contains("cdn.jsdelivr.net"))
        #expect(output.contains("integrity="))
        #expect(output.contains("crossorigin=\"anonymous\""))
    }

    // MARK: - Syntax highlighting

    @Test("Body includes syntax highlighting script when highlighters are present")
    func syntaxHighlightingScript() async throws {
        publishingContext.syntaxHighlighters.append(.swift)
        let element = Body()
        let output = element.markupString()
        #expect(output.contains("/js/syntax-highlighting.js"))
    }

    // MARK: - Tooltip initialization

    @Test("Body includes tooltip initialization when content has tooltip triggers")
    func tooltipInitScript() async throws {
        let element = Body {
            Text("Hover me")
                .customAttribute(name: "data-bs-toggle", value: "tooltip")
        }
        let output = element.markupString()
        #expect(output.contains("bootstrap.Tooltip"))
    }

    // MARK: - Line number visibility

    @Test("Body with visible line numbers adds line-numbers class")
    func visibleLineNumbers() async throws {
        try PublishingContext.initialize(for: LineNumbersSite(), from: #filePath)
        let element = Body()
        let output = element.markupString()
        #expect(output.contains("line-numbers"))
    }

    @Test("Body with visible line numbers and custom start adds data-start attribute")
    func lineNumbersCustomStart() async throws {
        try PublishingContext.initialize(
            for: LineNumbersSite(lineNumberVisibility: .visible(firstLine: 5, linesWrap: false)),
            from: #filePath
        )
        let element = Body()
        let output = element.markupString()
        #expect(output.contains("data-start=\"5\""))
    }

    @Test("Body with visible line numbers and wrapping adds pre-wrap style")
    func lineNumbersWrapping() async throws {
        try PublishingContext.initialize(
            for: LineNumbersSite(lineNumberVisibility: .visible(firstLine: 1, linesWrap: true)),
            from: #filePath
        )
        let element = Body()
        let output = element.markupString()
        #expect(output.contains("white-space: pre-wrap"))
    }
}

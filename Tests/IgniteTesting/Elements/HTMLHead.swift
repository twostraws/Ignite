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
class HTMLHeadTests: IgniteSuite {
    @Test("Highlighting meta tags are sorted")
    func highlighterThemesAreSorted() async throws {
        let links = MetaLink.highlighterThemeMetaLinks(for: [.xcodeDark, .githubDark, .twilight])
        let output = links.map { $0.render() }

        #expect(
            output == [
                "<link href=\"/css/prism-github-dark.css\" rel=\"stylesheet\" data-highlight-theme=\"github-dark\" />",
                "<link href=\"/css/prism-twilight.css\" rel=\"stylesheet\" data-highlight-theme=\"twilight\" />",
                "<link href=\"/css/prism-xcode-dark.css\" rel=\"stylesheet\" data-highlight-theme=\"xcode-dark\" />"
            ]
        )
    }
}

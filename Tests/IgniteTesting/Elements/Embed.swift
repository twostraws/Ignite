//
//  Embed.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Embed` element.
@Suite("Embed Tests")
@MainActor
class EmbedTests: IgniteTestSuite {
    @Test("Basic Embed")
    func basicEmbed() async throws {
        let element = Embed(youTubeID: "dQw4w9WgXcQ", title: "There was only ever going to be one video used here.")
        let output = element.render()

        #expect(output == """
        <div><iframe src="https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ" \
        title="There was only ever going to be one video used here." \
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; \
        gyroscope; picture-in-picture; web-share"></iframe></div>
        """)
    }
}

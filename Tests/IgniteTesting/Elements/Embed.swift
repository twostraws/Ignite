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
        let output = element.markupString()

        #expect(output == """
        <div><iframe src="https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ" \
        title="There was only ever going to be one video used here." \
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; \
        gyroscope; picture-in-picture; web-share"></iframe></div>
        """)
    }

    @Test("Vimeo embed uses correct URL format")
    func vimeoEmbed() async throws {
        let element = Embed(vimeoID: 123456, title: "Vimeo Test")
        let output = element.markupString()
        #expect(output.contains("src=\"https://player.vimeo.com/video/123456\""))
        #expect(output.contains("title=\"Vimeo Test\""))
    }

    @Test("Spotify embed uses correct URL format with content type and theme")
    func spotifyEmbed() async throws {
        let element = Embed(spotifyID: "abc123", title: "My Track", type: .track, theme: 1)
        let output = element.markupString()
        #expect(output.contains("src=\"https://open.spotify.com/embed/track/abc123?utm_source=generator&theme=1\""))
        #expect(output.contains("title=\"My Track\""))
    }

    @Test("Spotify playlist type uses playlist in URL")
    func spotifyPlaylistEmbed() async throws {
        let element = Embed(spotifyID: "pl123", title: "My Playlist", type: .playlist)
        let output = element.markupString()
        #expect(output.contains("/embed/playlist/pl123"))
    }

    @Test("Generic URL embed renders provided URL")
    func genericURLEmbed() async throws {
        let element = Embed(title: "Custom", url: "https://example.com/widget")
        let output = element.markupString()
        #expect(output.contains("src=\"https://example.com/widget\""))
        #expect(output.contains("title=\"Custom\""))
    }
}

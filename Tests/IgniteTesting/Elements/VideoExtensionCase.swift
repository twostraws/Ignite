import SwiftSoup
import Testing

@testable import Ignite

@Suite("Video extension case")
struct VideoExtensionCaseTests {
    @Test("Video sources preserve URLs with uppercase and mixed-case extensions", .publishingContext(), arguments: [
        ("https://example.com/Videos/Demo.MP4?token=AbC123&download=1", "video/mp4"),
        ("/Videos/Demo.WebM#Preview", "video/webm"),
        ("/Videos/Demo.MOV", "video/quicktime"),
        ("/Videos/Demo.mp4", "video/mp4")
    ])
    func sourcePreservesURL(filename: String, mimeType: String) async throws {
        let markup = Video(filename).markup().string
        let document = try SwiftSoup.parse(markup)
        let sources = try document.select("video source").array()
        #expect(sources.count == 1)
        let source = try #require(sources.first)

        #expect(try source.attr("src") == filename)
        #expect(try source.attr("type") == mimeType)
    }

    @Test("Mixed sources retain recognized formats and their order", .publishingContext())
    func mixedSourcesPreserveOrder() async throws {
        let markup = Video("/Videos/Demo.MP4", "/Videos/Demo.xyz", "/Videos/Demo.WebM").markup().string
        let document = try SwiftSoup.parse(markup)
        let sources = try document.select("video source").array()

        #expect(try sources.map { try $0.attr("src") } == ["/Videos/Demo.MP4", "/Videos/Demo.WebM"])
        #expect(try sources.map { try $0.attr("type") } == ["video/mp4", "video/webm"])
    }

    @Test("Unknown extensions still produce no source", .publishingContext())
    func unknownExtensionRemainsUnsupported() async throws {
        let markup = Video("/Videos/Demo.XYZ").markup().string
        let document = try SwiftSoup.parse(markup)

        #expect(try document.select("video source").isEmpty())
        #expect(markup.contains("Your browser does not support the video tag."))
    }
}

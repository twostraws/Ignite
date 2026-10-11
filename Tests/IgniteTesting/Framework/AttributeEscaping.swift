import Foundation
import Testing

@testable import Ignite

@Suite("Attribute escaping")
struct AttributeEscapingTests {
    @Test("Author metadata preserves quotes as one attribute value", .publishingContext(), arguments: [
        "Taylor Smith",
        #"Taylor "TJ" Smith"#,
        #"Taylor "TJ" O'Brien & friends <team>"#,
        #"Taylor" data-extra="unexpected"#
    ])
    func authorMetadataPreservesQuotedContent(author: String) async throws {
        let markup = MetaTag(name: "author", content: author).markup().string
        let document = try XMLDocument(data: Data(markup.utf8), options: .documentTidyHTML)
        let element = try #require(document.nodes(forXPath: "//meta[@name='author']").first as? XMLElement)

        #expect(element.attribute(forName: "content")?.stringValue == author)
        #expect(element.attributes?.count == 2)
    }

    @Test("Image alternative text preserves quotes", .publishingContext(), arguments: [
        "Tap the Add button",
        #"Tap the "Add" button"#
    ])
    func imageAlternativeTextPreservesQuotes(description: String) async throws {
        let markup = Image("/images/example.png", description: description).markup().string
        let document = try XMLDocument(data: Data(markup.utf8), options: .documentTidyHTML)
        let element = try #require(document.nodes(forXPath: "//img").first as? XMLElement)

        #expect(element.attribute(forName: "alt")?.stringValue == description)
        #expect(element.attributes?.count == 2)
    }

    @Test("Existing attribute entities and ordinary values keep their serialization", arguments: [
        "",
        "Already &quot;quoted&quot; &amp; encoded",
        "Already &#34;quoted&#34; and &#x22;quoted&#x22;",
        "https://example.com/?first=1&second=2",
        "Café, O'Brien & friends <team>"
    ])
    func existingAttributeValuesRemainCompatible(value: String) {
        let attribute = Attribute(name: "title", value: value)

        #expect(attribute.description == "title=\"\(value)\"")
        #expect(attribute.value == value)
    }
}

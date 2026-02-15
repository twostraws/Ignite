//
//  EdgeAdjust.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `EdgeAdjust` helpers.
@Suite("EdgeAdjust Tests")
@MainActor
class EdgeAdjustTests: IgniteTestSuite {
    // MARK: - Class-based edge adjustment (semantic amounts)

    @Test("All edges class uses no axis prefix")
    func allEdgesClass() async throws {
        let element = Text("Test")
        let classes = element.edgeAdjustedClasses(prefix: "p", .all, 3)
        #expect(classes == ["p-3"])
    }

    @Test("Horizontal edges class uses x prefix")
    func horizontalEdgesClass() async throws {
        let element = Text("Test")
        let classes = element.edgeAdjustedClasses(prefix: "p", .horizontal, 2)
        #expect(classes == ["px-2"])
    }

    @Test("Vertical edges class uses y prefix")
    func verticalEdgesClass() async throws {
        let element = Text("Test")
        let classes = element.edgeAdjustedClasses(prefix: "p", .vertical, 2)
        #expect(classes == ["py-2"])
    }

    @Test("Individual edge classes", arguments: zip(
        [Edge.top, .bottom, .leading, .trailing],
        ["pt-1", "pb-1", "ps-1", "pe-1"]))
    func individualEdgeClasses(edge: Edge, expected: String) async throws {
        let element = Text("Test")
        let classes = element.edgeAdjustedClasses(prefix: "p", edge, 1)
        #expect(classes == [expected])
    }

    @Test("Multiple individual edges produce multiple classes")
    func multipleIndividualEdges() async throws {
        let element = Text("Test")
        let edges: Edge = [.top, .trailing]
        let classes = element.edgeAdjustedClasses(prefix: "m", edges, 3)
        #expect(classes.contains("mt-3"))
        #expect(classes.contains("me-3"))
        #expect(classes.count == 2)
    }

    @Test("Horizontal class takes precedence over leading and trailing classes")
    func horizontalClassPrecedence() async throws {
        let element = Text("Test")
        let edges: Edge = [.horizontal, .leading]
        let classes = element.edgeAdjustedClasses(prefix: "p", edges, 2)
        #expect(classes == ["px-2"])
    }

    @Test("Vertical class takes precedence over top and bottom classes")
    func verticalClassPrecedence() async throws {
        let element = Text("Test")
        let edges: Edge = [.vertical, .top]
        let classes = element.edgeAdjustedClasses(prefix: "p", edges, 2)
        #expect(classes == ["py-2"])
    }

    // MARK: - Style-based edge adjustment (exact values)

    @Test("All edges style uses shorthand property")
    func allEdgesStyle() async throws {
        let element = Text("Test")
        let styles = element.edgeAdjustedStyles(prefix: "padding", .all, "20px")
        #expect(styles == [InlineStyle("padding", value: "20px")])
    }

    @Test("Individual edge styles", arguments: zip(
        [Edge.top, .bottom, .leading, .trailing],
        ["padding-top", "padding-bottom", "padding-left", "padding-right"]))
    func individualEdgeStyles(edge: Edge, expectedProperty: String) async throws {
        let element = Text("Test")
        let styles = element.edgeAdjustedStyles(prefix: "padding", edge, "10px")
        #expect(styles == [InlineStyle(expectedProperty, value: "10px")])
    }

    @Test("Horizontal styles generate leading and trailing declarations")
    func horizontalStyles() async throws {
        let element = Text("Test")
        let styles = element.edgeAdjustedStyles(prefix: "padding", .horizontal, "8px")
        #expect(styles == [
            InlineStyle("padding-left", value: "8px"),
            InlineStyle("padding-right", value: "8px")
        ])
    }

    @Test("Vertical styles generate top and bottom declarations")
    func verticalStyles() async throws {
        let element = Text("Test")
        let styles = element.edgeAdjustedStyles(prefix: "padding", .vertical, "8px")
        #expect(styles == [
            InlineStyle("padding-top", value: "8px"),
            InlineStyle("padding-bottom", value: "8px")
        ])
    }
}

//
//  Alignment.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Alignment` type.
@Suite("Alignment Tests")
struct AlignmentTests {
    @Test("topLeading has leading horizontal and top vertical", .publishingContext())
    func topLeadingValues() async throws {
        #expect(Alignment.topLeading.horizontal == .leading)
        #expect(Alignment.topLeading.vertical == .top)
    }

    @Test("top has center horizontal and top vertical", .publishingContext())
    func topValues() async throws {
        #expect(Alignment.top.horizontal == .center)
        #expect(Alignment.top.vertical == .top)
    }

    @Test("topTrailing has trailing horizontal and top vertical", .publishingContext())
    func topTrailingValues() async throws {
        #expect(Alignment.topTrailing.horizontal == .trailing)
        #expect(Alignment.topTrailing.vertical == .top)
    }

    @Test("leading has leading horizontal and center vertical", .publishingContext())
    func leadingValues() async throws {
        #expect(Alignment.leading.horizontal == .leading)
        #expect(Alignment.leading.vertical == .center)
    }

    @Test("center has center horizontal and center vertical", .publishingContext())
    func centerValues() async throws {
        #expect(Alignment.center.horizontal == .center)
        #expect(Alignment.center.vertical == .center)
    }

    @Test("trailing has trailing horizontal and center vertical", .publishingContext())
    func trailingValues() async throws {
        #expect(Alignment.trailing.horizontal == .trailing)
        #expect(Alignment.trailing.vertical == .center)
    }

    @Test("bottomLeading has leading horizontal and bottom vertical", .publishingContext())
    func bottomLeadingValues() async throws {
        #expect(Alignment.bottomLeading.horizontal == .leading)
        #expect(Alignment.bottomLeading.vertical == .bottom)
    }

    @Test("bottom has center horizontal and bottom vertical", .publishingContext())
    func bottomValues() async throws {
        #expect(Alignment.bottom.horizontal == .center)
        #expect(Alignment.bottom.vertical == .bottom)
    }

    @Test("bottomTrailing has trailing horizontal and bottom vertical", .publishingContext())
    func bottomTrailingValues() async throws {
        #expect(Alignment.bottomTrailing.horizontal == .trailing)
        #expect(Alignment.bottomTrailing.vertical == .bottom)
    }

    @Test("Custom alignment uses provided values", .publishingContext())
    func customAlignmentUsesProvidedValues() async throws {
        let alignment = Alignment(horizontal: .trailing, vertical: .top)
        #expect(alignment.horizontal == .trailing)
        #expect(alignment.vertical == .top)
    }

    @Test("Default alignment is center-center", .publishingContext())
    func defaultAlignmentIsCenterCenter() async throws {
        let alignment = Alignment()
        #expect(alignment.horizontal == .center)
        #expect(alignment.vertical == .center)
    }

    @Test("Bootstrap classes for topLeading", .publishingContext())
    func bootstrapClassesForTopLeading() async throws {
        #expect(Alignment.topLeading.bootstrapClasses == ["justify-content-start", "align-items-start"])
    }

    @Test("Bootstrap classes for center", .publishingContext())
    func bootstrapClassesForCenter() async throws {
        #expect(Alignment.center.bootstrapClasses == ["justify-content-center", "align-items-center"])
    }

    @Test("Bootstrap classes for bottomTrailing", .publishingContext())
    func bootstrapClassesForBottomTrailing() async throws {
        #expect(Alignment.bottomTrailing.bootstrapClasses == ["justify-content-end", "align-items-end"])
    }

    @Test("Equatable conformance", .publishingContext())
    func equatableConformance() async throws {
        #expect(Alignment.center == Alignment.center)
        #expect(Alignment.topLeading == Alignment(horizontal: .leading, vertical: .top))
        #expect(Alignment.center != Alignment.topLeading)
    }
}

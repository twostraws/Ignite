//
//  ImageFit.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ImageFit` type.
@Suite("ImageFit Tests")
@MainActor
struct ImageFitTests {
    @Test("Raw values match CSS object-fit values")
    func rawValues() async throws {
        #expect(ImageFit.fill.rawValue == "fill")
        #expect(ImageFit.fit.rawValue == "contain")
        #expect(ImageFit.cover.rawValue == "cover")
        #expect(ImageFit.scaleDown.rawValue == "scale")
        #expect(ImageFit.none.rawValue == "none")
    }
}

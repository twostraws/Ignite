//
//  AnchorPoint.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `AnchorPoint` type.
@Suite("AnchorPoint Tests")
@MainActor
struct AnchorPointTests {
    static let anchorPoints: [AnchorPoint] = [
        .center, .topLeft, .topRight,
        .bottomLeft, .bottomRight, .top,
        .bottom, .left, .right
    ]

    static let anchorPointCSSValues = [
        "center", "top left", "top right",
        "bottom left", "bottom right", "top",
        "bottom", "left", "right"
    ]

    @Test("Anchor point", arguments: await zip(anchorPoints, anchorPointCSSValues))
    func anchorPoint(_ anchorPoint: AnchorPoint, css: String) async throws {
        #expect(anchorPoint.value == css)
    }

    static let xCoordinates = ["1", "2", "3", "4", "5"]
    static let yCoordinates = ["6", "7", "8", "9", "10"]

    @Test("Custom anchor point", arguments: zip(await Self.xCoordinates, await Self.yCoordinates))
    func customAnchorPoint(xCoord: String, yCoord: String) async throws {
        let element = AnchorPoint.custom(x: xCoord, y: yCoord)
        #expect(element.value == "\(xCoord) \(yCoord)")
    }
}

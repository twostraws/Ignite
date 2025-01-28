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
    @Test("Test the center anchor point.")
    func centerAnchorPoint() async throws {
        let element = AnchorPoint.center
        #expect(element.value == "center")
    }

    @Test("Test the top left anchor point.")
    func topLeftAnchorPoint() async throws {
        let element = AnchorPoint.topLeft
        #expect(element.value == "top left")
    }

    @Test("Test the top right anchor point.")
    func topRightAnchorPoint() async throws {
        let element = AnchorPoint.topRight
        #expect(element.value == "top right")
    }

    @Test("Test the bottom left anchor point.")
    func bottomLeftAnchorPoint() async throws {
        let element = AnchorPoint.bottomLeft
        #expect(element.value == "bottom left")
    }

    @Test("Test the bottom right anchor point.")
    func bottomRightAnchorPoint() async throws {
        let element = AnchorPoint.bottomRight
        #expect(element.value == "bottom right")
    }

    @Test("Test the top anchor point.")
    func topAnchorPoint() async throws {
        let element = AnchorPoint.top
        #expect(element.value == "top")
    }

    @Test("Test the bottom anchor point.")
    func bottomAnchorPoint() async throws {
        let element = AnchorPoint.bottom
        #expect(element.value == "bottom")
    }

    @Test("Test the left anchor point.")
    func leftAnchorPoint() async throws {
        let element = AnchorPoint.left
        #expect(element.value == "left")
    }

    @Test("Test the right anchor point.")
    func rightAnchorPoint() async throws {
        let element = AnchorPoint.right
        #expect(element.value == "right")
    }

    static let xCoordinates: [String] = ["1", "2", "3", "4", "5"]
    static let yCoordinates: [String] = ["6", "7", "8", "9", "10"]

    @Test("Test the custom anchor point.", arguments: zip(await Self.xCoordinates, await Self.yCoordinates))
    func customAnchorPoint(xCoord: String, yCoord: String) async throws {
        let element = AnchorPoint.custom(x: xCoord, y: yCoord)
        #expect(element.value == "\(xCoord) \(yCoord)")
    }
}

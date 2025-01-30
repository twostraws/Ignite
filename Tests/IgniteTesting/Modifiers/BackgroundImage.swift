//
//  BackgroundImage.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `BackgroundImage` modifier.
@Suite("BackgroundImage Tests")
@MainActor
struct BackgroundImageTests {
    @Test("Test background image modifier.")
    func render() async throws {
        let element =
        Text {
            "Hello World!"
        }.background(image: "assets/image.png", contentMode: .fill, position: .center, repeats: false)
        #expect(element.render() ==
                """
                <p \
                style=\"background-image: url('assets/image.png'); \
                background-position: center center; \
                background-repeat: no-repeat; \
                background-size: cover\">Hello World!\
                </p>
                """
        )
    }

    @Test("Test original background image content mode.")
    func original() async throws {
        let element = BackgroundImageContentMode.original
        #expect(element.css == "auto")
    }

    @Test("Test fill background image content mode.")
    func fill() async throws {
        let element = BackgroundImageContentMode.fill
        #expect(element.css == "cover")
    }

    @Test("Test fit background image content mode.")
    func fit() async throws {
        let element = BackgroundImageContentMode.fit
        #expect(element.css == "contain")
    }

    @Test("Test size background image content mode.")
    func size() async throws {
        let element = BackgroundImageContentMode.size(width: "25px", height: "25px")
        #expect(element.css == "25px 25px")
    }

    @Test("Test percent value representation.")
    func percent() async throws {
        let element = BackgroundPosition.Value.percent(50)
        #expect(element.css == "50%")
    }

    @Test("Test pixel value representation.")
    func pixel() async throws {
        let element = BackgroundPosition.Value.pixel(50)
        #expect(element.css == "50px")
    }

    @Test("Test default background image position.")
    func defaultBackgroundImagePosition() async throws {
        let element = BackgroundPosition()
        #expect(element.css == "center center")
    }

    @Test("Test center background position.")
    func center() async throws {
        let element = BackgroundPosition.center
        #expect(element.css == "center center")
    }

    @Test("Test top background position.")
    func top() async throws {
        let element = BackgroundPosition.top
        #expect(element.css == "center top")
    }

    @Test("Test bottom background position.")
    func bottom() async throws {
        let element = BackgroundPosition.bottom
        #expect(element.css == "center bottom")
    }

    @Test("Test leading background position.")
    func leading() async throws {
        let element = BackgroundPosition.leading
        #expect(element.css == "left center")
    }

    @Test("Test trailing background position.")
    func trailing() async throws {
        let element = BackgroundPosition.trailing
        #expect(element.css == "right center")
    }

    @Test("Test topLeading background position.")
    func topLeading() async throws {
        let element = BackgroundPosition.topLeading
        #expect(element.css == "left top")
    }

    @Test("Test topTrailing background position.")
    func topTrailing() async throws {
        let element = BackgroundPosition.topTrailing
        #expect(element.css == "right top")
    }

    @Test("Test bottomLeading background position.")
    func bottomLeading() async throws {
        let element = BackgroundPosition.bottomLeading
        #expect(element.css == "left bottom")
    }

    @Test("Test bottomTrailing background position.")
    func bottomTrailing() async throws {
        let element = BackgroundPosition.bottomTrailing
        #expect(element.css == "right bottom")
    }

    @Test("Test positioning of background relative to vertical and horizontal alignment.")
    func position() async throws {
        let element = BackgroundPosition.position(
            vertical: BackgroundPosition.Value.pixel(25),
            relativeTo: BackgroundPosition.VerticalAlignment.center,
            horizontal: BackgroundPosition.Value.pixel(25),
            relativeTo: BackgroundPosition.HorizontalAlignment.center
        )
        #expect(element.css == "calc(50% + 25px) calc(50% + 25px)")
    }

    @Test("Test bakcgorund position initializer with Vertical and horizonal alignment.")
    func initWithAlignment() async throws {
        let element = BackgroundPosition(vertical: .top, horizontal: .leading)
        #expect(element.css == "left top")
    }
}

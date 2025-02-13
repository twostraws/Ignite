//
//  FontModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Helper function to simulate registerClasses logic
func simulateRegisterClasses(for responsiveSize: ResponsiveFontSize) -> String {
    let className = "font-" + responsiveSize.breakpointValues.description.truncatedHash

    return className
}

/// Tests for the `FontModifier` modifier.
@Suite("FontModifier Tests")
@MainActor
struct FontModifierTests {
    @Test("Basic Font Application")
    func basicFontApplication() async throws {
        let element = Text {
            Span("Sample text")
                .font(Font(name: "Arial", size: .px(16), weight: .regular))
        }

        let output = element.render()

        #expect(
            output == "<p><div style=\"font-family: Arial; font-size: 16px; font-weight: 400\">" +
                      "<span class=\"font-inherit\">Sample text</span></div></p>"
        )
    }

    @Test("Font Weight Application")
    func fontWeightApplication() async throws {
        let element = Text {
            Span("Sample text")
                .font(Font(name: "Arial", size: .px(16), weight: .bold))
        }

        let output = element.render()

        #expect(
            output == "<p><div style=\"font-family: Arial; font-size: 16px; font-weight: 700\">" +
                      "<span class=\"font-inherit\">Sample text</span></div></p>"
        )
    }

    @Test("Font Size Application")
    func fontSizeApplication() async throws {
        let element = Text {
            Span("Sample text")
                .font(Font(name: "Arial", size: .em(1.5), weight: .regular))
        }

        let output = element.render()

        #expect(
            output == "<p><div style=\"font-family: Arial; font-size: 1.5em; font-weight: 400\">" +
                      "<span class=\"font-inherit\">Sample text</span></div></p>"
        )
    }

    @Test("Font Family Application")
    func fontFamilyApplication() async throws {
        let element = Text {
            Span("Sample text")
                .font(Font(name: "Times New Roman", size: .px(16), weight: .regular))
        }

        let output = element.render()

        #expect(
            output == "<p><div style=\"font-family: Times New Roman; font-size: 16px; font-weight: 400\">" +
                      "<span class=\"font-inherit\">Sample text</span></div></p>"
        )
    }

    @Test("Responsive Font Size Application")
    func responsiveFontSizeApplication() async throws {
        // Create a responsive font size using the ResponsiveValue.responsive method
        let responsiveFontSize = ResponsiveFontSize.responsive(
            small: .px(12),
            medium: .px(16),
            large: .px(20)
        )

        let element = Text {
            Span("Sample text")
                .font(Font(
                    name: "Arial",
                    style: .body,
                    size: responsiveFontSize,
                    weight: .regular
                ))
        }

        // Simulate registerClasses logic to get the expected class name
        let expectedClassName = simulateRegisterClasses(for: responsiveFontSize)

        let output = element.render()

        // Check for the presence of the responsive font-size class
        #expect(output.contains(expectedClassName))
    }
}

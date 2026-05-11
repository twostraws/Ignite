//
// PublishingContextPreconstruction.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

private struct PreconstructedStyle: Style {
    func style(content: StyledHTML, environment: EnvironmentConditions) -> StyledHTML {
        content.style(.color, "red")
    }
}

/// Tests for HTML constructed before a publishing context is active.
@Suite("PublishingContext Preconstruction Tests")
struct PublishingContextPreconstructionTests {
    @Test("Styled elements can be constructed before a publishing context")
    func styledElementsCanBeConstructedBeforePublishingContext() throws {
        let customFont = Font.custom("Merriweather", size: .px(18))
        let responsiveFont = Font.Responsive.custom(
            "Inter",
            size: .responsive(.px(16), medium: .px(24))
        ).font

        let element = Group {
            Text("Custom font")
                .font(customFont)

            Text("Responsive font")
                .font(responsiveFont)

            Text("Hidden")
                .hidden(.responsive(false, medium: true))

            Text("Styled")
                .style(PreconstructedStyle())
        }

        let standaloneOutput = element.markupString()
        #expect(standaloneOutput.contains("Custom font"))
        #expect(standaloneOutput.contains("Responsive font"))
        #expect(standaloneOutput.contains("Hidden"))
        #expect(standaloneOutput.contains("Styled"))

        let context = try PublishingContext.initialize(for: TestSite(), from: #filePath)

        let output = PublishingContext.withCurrent(context) {
            element.markupString()
        }

        let responsiveCSS = context.cssManager.generateAllRules(themes: context.site.allThemes)

        #expect(output.contains("font-"))
        #expect(output.contains("style-"))
        #expect(output.contains("preconstructed"))
        #expect(context.cssManager.customFonts.contains(customFont))
        #expect(context.cssManager.customFonts.contains(responsiveFont))
        #expect(context.styleManager.containsRegisteredStyle(named: PreconstructedStyle().className))
        #expect(responsiveCSS.contains("font-size: 16px"))
        #expect(responsiveCSS.contains("display: none"))
    }

    @Test("Markup string-interpolation registers publishing context")
    func markupInterpolationRegistersPublishingContext() throws {
        let context = try PublishingContext.initialize(for: TestSite(), from: #filePath)
        let font = Font.custom("SomeFont", size: .px(12))
        var attrs = CoreAttributes()
        attrs.append(publishingRegistration: .fontFamily(font))

        PublishingContext.withCurrent(context) {
            let _: Markup = "<p\(attrs)>hello</p>"
        }

        #expect(context.cssManager.customFonts.contains(font))
    }

    @Test("Animated elements can be rendered before a publishing context")
    func animatedElementsCanBeRenderedBeforePublishingContext() throws {
        let element = Text("Animate me")
            .animation(Animation.bounce, on: .hover)

        let standaloneOutput = element.markupString()
        #expect(standaloneOutput.contains("Animate me"))
        #expect(standaloneOutput.contains("animation-"))

        let context = try PublishingContext.initialize(for: TestSite(), from: #filePath)

        _ = PublishingContext.withCurrent(context) {
            element.markupString()
        }

        let temporaryCSS = FileManager.default.temporaryDirectory
            .appending(path: "ignite-animation-\(UUID().uuidString).css")
        try "base".write(to: temporaryCSS, atomically: true, encoding: .utf8)
        defer {
            try? FileManager.default.removeItem(at: temporaryCSS)
        }

        context.animationManager.write(to: temporaryCSS)

        let generatedCSS = try String(contentsOf: temporaryCSS, encoding: .utf8)
        #expect(generatedCSS.contains("@keyframes"))
        #expect(generatedCSS.contains("animation-"))
    }
}

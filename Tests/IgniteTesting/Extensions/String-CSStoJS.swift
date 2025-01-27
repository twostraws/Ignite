//
//  String-CSStoJS.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-CSStoJS` extension.
@Suite("String-CSStoJS Tests")
@MainActor
struct StringCSStoJSTests {
    @Test("CSS-JS conversion for zero hyphen names")
    func convertingCSSNamesToJS_forZeroHyphenNames() async throws {
        // Given
        let cssName1 = "color"
        let cssName2 = "margin"
        // When
        let jsName1 = cssName1.convertingCSSNamesToJS()
        let jsName2 = cssName2.convertingCSSNamesToJS()
        // Then
        #expect(jsName1 == "color")
        #expect(jsName2 == "margin")
    }

    @Test("CSS-JS conversion for single hyphen names")
    func convertingCSSNamesToJS_forSingleHyphenNames() async throws {
        // Given
        let cssName1 = "background-color"
        let cssName2 = "font-size"
        let cssName3 = "writing-mode"
        let cssName4 = "transform-origin"
        // When
        let jsName1 = cssName1.convertingCSSNamesToJS()
        let jsName2 = cssName2.convertingCSSNamesToJS()
        let jsName3 = cssName3.convertingCSSNamesToJS()
        let jsName4 = cssName4.convertingCSSNamesToJS()
        // Then
        #expect(jsName1 == "backgroundColor")
        #expect(jsName2 == "fontSize")
        #expect(jsName3 == "writingMode")
        #expect(jsName4 == "transformOrigin")
    }

    @Test("CSS-JS conversion for multiple hyphen names")
    func convertingCSSNamesToJS_forMultipleHyphenNames() async throws {
        // Given
        let cssName1 = "font-size-adjust"
        let cssName2 = "animation-timing-function"
        let cssName3 = "transition-timing-function"
        let cssName4 = "border-top-left-radius"
        // When
        let jsName1 = cssName1.convertingCSSNamesToJS()
        let jsName2 = cssName2.convertingCSSNamesToJS()
        let jsName3 = cssName3.convertingCSSNamesToJS()
        let jsName4 = cssName4.convertingCSSNamesToJS()
        // Then
        #expect(jsName1 == "fontSizeAdjust")
        #expect(jsName2 == "animationTimingFunction")
        #expect(jsName3 == "transitionTimingFunction")
        #expect(jsName4 == "borderTopLeftRadius")
    }

    @Test("CSS-JS conversion for pre/post-hyphenated names")
    func convertingCSSNamesToJS_forPreOrPostHyphenatedNames() async throws {
        // Given
        let cssName1 = "--background-color"
        let cssName2 = "--font-size"
        let cssName3 = "-writing-mode-"
        let cssName4 = "-transform-origin-"
        // When
        let jsName1 = cssName1.convertingCSSNamesToJS()
        let jsName2 = cssName2.convertingCSSNamesToJS()
        let jsName3 = cssName3.convertingCSSNamesToJS()
        let jsName4 = cssName4.convertingCSSNamesToJS()
        // Then
        #expect(jsName1 == "backgroundColor")
        #expect(jsName2 == "fontSize")
        #expect(jsName3 == "writingMode")
        #expect(jsName4 == "transformOrigin")
    }

    @Test("CSS-JS conversion for names with numbers")
    func convertingCSSNamesToJS_forNamesWithNumbers() async throws {
        // Given
        let cssName1 = "font-size-12"
        let cssName2 = "border-1px"
        // When
        let jsName1 = cssName1.convertingCSSNamesToJS()
        let jsName2 = cssName2.convertingCSSNamesToJS()
        // Then
        #expect(jsName1 == "fontSize12")
        #expect(jsName2 == "border1px")
    }

    @Test("CSS-JS conversion for uppercased names")
    func convertingCSSNamesToJS_forUppercasedNames() async throws {
        // Given
        let cssName1 = "MARGIN-TOP"
        let cssName2 = "BORDER-1PX"
        let cssName3 = "FONT-SIZE-12"
        // When
        let jsName1 = cssName1.convertingCSSNamesToJS()
        let jsName2 = cssName2.convertingCSSNamesToJS()
        let jsName3 = cssName3.convertingCSSNamesToJS()
        // Then
        #expect(jsName1 == "MARGINTOP")
        #expect(jsName2 == "BORDER1PX")
        #expect(jsName3 == "FONTSIZE12")
    }

    @Test("CSS-JS conversion for mixed case names")
    func convertingCSSNamesToJS_forMixedCaseNames() async throws {
        // Given
        let cssName1 = "background-Color"
        let cssName2 = "BoRdEr-rAdIuS"
        let cssName3 = "transform-oRIGIN"
        // When
        let jsName1 = cssName1.convertingCSSNamesToJS()
        let jsName2 = cssName2.convertingCSSNamesToJS()
        let jsName3 = cssName3.convertingCSSNamesToJS()
        // Then
        #expect(jsName1 == "backgroundColor")
        #expect(jsName2 == "BoRdErRAdIuS")
        #expect(jsName3 == "transformORIGIN")
    }

    @Test("CSS-JS conversion for names with special characters")
    func convertingCSSNamesToJS_forNamesWithSpecialCharacters() async throws {
        // Given
        let cssName1 = "--border-top-left-radius"
        let cssName2 = "--grid_column_2"
        let cssName3 = "--important-value!"
        let cssName4 = "--custom-color#1"
        let cssName5 = "--active-state@key"
        let cssName6 = "--background-color#ff5733"
        let cssName7 = "--main- color"
        let cssName8 = "--font-size$special"
        let cssName9 = "--border-radius+5"
        let cssName10 = "--padding~10px"
        // When
        let jsName1 = cssName1.convertingCSSNamesToJS()
        let jsName2 = cssName2.convertingCSSNamesToJS()
        let jsName3 = cssName3.convertingCSSNamesToJS()
        let jsName4 = cssName4.convertingCSSNamesToJS()
        let jsName5 = cssName5.convertingCSSNamesToJS()
        let jsName6 = cssName6.convertingCSSNamesToJS()
        let jsName7 = cssName7.convertingCSSNamesToJS()
        let jsName8 = cssName8.convertingCSSNamesToJS()
        let jsName9 = cssName9.convertingCSSNamesToJS()
        let jsName10 = cssName10.convertingCSSNamesToJS()
        // Then
        #expect(jsName1 == "borderTopLeftRadius")
        #expect(jsName2 == "grid_column_2")
        #expect(jsName3 == "importantValue!")
        #expect(jsName4 == "customColor#1")
        #expect(jsName5 == "activeState@key")
        #expect(jsName6 == "backgroundColor#ff5733")
        #expect(jsName7 == "main color")
        #expect(jsName8 == "fontSize$special")
        #expect(jsName9 == "borderRadius+5")
        #expect(jsName10 == "padding~10px")
    }

    @Test("CSS-JS conversion for an empty string")
    func convertingCSSNamesToJS_forAnEmptyString() async throws {
        // Given
        let cssName = ""
        // When
        let jsName = cssName.convertingCSSNamesToJS()
        // Then
        #expect(jsName == "")
    }
}

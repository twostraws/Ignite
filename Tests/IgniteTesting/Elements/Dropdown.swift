//
//  Dropdown.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Dropdown` element.
@Suite("Dropdown Tests")
@MainActor
class DropdownTests: IgniteTestSuite {
    @Test("basic Dropdown Text")
    func basicDropdownText() async throws {
        let element = Dropdown("Click Me") {
            Text("Content1")
            Text("Content2")
            Text("Or you can just…")
        }.role(.primary)

        let output = element.render().string

        let expectedOutput = """
        <div class="dropdown">
            <button type="button" class="btn btn-primary dropdown-toggle"
                data-bs-toggle="dropdown" aria-expanded="false">Click Me</button>
            <ul class="dropdown-menu">
                <li><p class="dropdown-header">Content1</p></li>
                <li><p class="dropdown-header">Content2</p></li>
                <li><p class="dropdown-header">Or you can just…</p></li>
            </ul>
        </div>
        """

        let normalizedOutput = output.replacingOccurrences(
            of: "\\s+", with: "", options: .regularExpression
        )
        let normalizedExpectedOutput = expectedOutput.replacingOccurrences(
            of: "\\s+", with: "", options: .regularExpression
        )

        #expect(normalizedOutput == normalizedExpectedOutput)
    }

    @Test("Dropdown Role")
    func dropdownRole() async throws {
        let element = Dropdown("Click Me") {
            Text("Content1")
        }.role(.secondary)

        let output = element.render().string

        let expectedOutput = """
        <div class="dropdown">
            <button type="button" class="btn btn-secondary dropdown-toggle"
                data-bs-toggle="dropdown" aria-expanded="false">Click Me</button>
            <ul class="dropdown-menu">
                <li><p class="dropdown-header">Content1</p></li>
            </ul>
        </div>
        """

        let normalizedOutput = output.replacingOccurrences(
            of: "\\s+", with: "", options: .regularExpression
        )
        let normalizedExpectedOutput = expectedOutput.replacingOccurrences(
            of: "\\s+", with: "", options: .regularExpression
        )

        #expect(normalizedOutput == normalizedExpectedOutput)
    }

    @Test("Empty Dropdown")
    func emptyDropdown() async throws {
        let element = Dropdown("Click Me") {}.role(.primary)

        let output = element.render().string

        let expectedOutput = """
        <div class="dropdown">
            <button type="button" class="btn btn-primary dropdown-toggle"
                data-bs-toggle="dropdown" aria-expanded="false">Click Me</button>
            <ul class="dropdown-menu"></ul>
        </div>
        """

        let normalizedOutput = output.replacingOccurrences(
            of: "\\s+", with: "", options: .regularExpression
        )
        let normalizedExpectedOutput = expectedOutput.replacingOccurrences(
            of: "\\s+", with: "", options: .regularExpression
        )

        #expect(normalizedOutput == normalizedExpectedOutput)
    }

    @Test("Dropdown Large Content")
    func dropdownLargeContent() async throws {
        let element = Dropdown("Click Me") {
            Text("Item 1")
            Text("Item 2")
        }.role(.primary)

        let output = element.render().string

        var expectedOutput = """
        <div class="dropdown">
            <button type="button" class="btn btn-primary dropdown-toggle"
                data-bs-toggle="dropdown" aria-expanded="false">Click Me</button>
            <ul class="dropdown-menu">
        """

        expectedOutput += """
            <li><p class="dropdown-header">Item 1</p></li>
            <li><p class="dropdown-header">Item 2</p></li>
        """

        expectedOutput += """
            </ul>
        </div>
        """

        let normalizedOutput = output.replacingOccurrences(
            of: "\\s+", with: "", options: .regularExpression
        )
        let normalizedExpectedOutput = expectedOutput.replacingOccurrences(
            of: "\\s+", with: "", options: .regularExpression
        )

        #expect(normalizedOutput == normalizedExpectedOutput)
    }
}

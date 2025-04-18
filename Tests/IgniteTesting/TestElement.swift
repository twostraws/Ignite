//
// TestElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@testable import Ignite

private struct TestSubElement: Element {
    var body: some Element {
        Text("Test Heading!")
    }
}

/// A custom element that modifiers can test.
struct TestElement: Element {
    var body: some HTML {
        TestSubElement()
        Text("Test Subheading")
        ControlLabel("Test Label")
    }
}

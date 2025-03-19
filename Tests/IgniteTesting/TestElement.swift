//
// TestElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@testable import Ignite

private struct TestSubElement: HTML {
    var body: some HTML {
        Text("Test Heading!")
    }
}

/// A custom element that modifiers can test.
struct TestElement: HTML {
    var body: some HTML {
        TestSubElement()
        Text("Test Subheading")
        FormFieldLabel(text: "Test Label")
    }
}

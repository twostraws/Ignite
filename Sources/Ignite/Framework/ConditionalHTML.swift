//
// ConditionalHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that conditionally renders one of two HTML content types based on a boolean condition.
@MainActor
public struct ConditionalHTML<TrueContent, FalseContent>: Sendable { // swiftlint:disable:this redundant_sendable
    /// The core attributes applied to the rendered HTML element.
    public var attributes = CoreAttributes()

    /// The storage mechanism that holds either the true or false content.
    let storage: Storage

    /// Internal storage enum that holds one of the two possible content types.
    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    /// Creates a conditional HTML container with the specified storage.
    /// - Parameter storage: The storage containing either true or false content.
    init(storage: Storage) {
        self.storage = storage
    }
}

extension ConditionalHTML: HTML where TrueContent: HTML, FalseContent: HTML {
    public var body: Never { fatalError() }

    /// Renders the conditional content as HTML markup.
    /// - Returns: The rendered markup from either the true or false content.
    public func render() -> Markup {
        switch storage {
        case .trueContent(let content):
            content.attributes(attributes).render()
        case .falseContent(let content):
            content.attributes(attributes).render()
        }
    }
}

extension ConditionalHTML: InlineElement, CustomStringConvertible
where TrueContent: InlineElement, FalseContent: InlineElement {
    public var body: Never { fatalError() }

    /// Renders the conditional content as inline HTML markup.
    /// - Returns: The rendered inline markup from either the true or false content.
    public func render() -> Markup {
        switch storage {
        case .trueContent(let content):
            content.attributes(attributes).render()
        case .falseContent(let content):
            content.attributes(attributes).render()
        }
    }
}

extension ConditionalHTML: ControlGroupElement
where TrueContent: ControlGroupElement, FalseContent: ControlGroupElement {
    /// Renders the conditional content as a control group element.
    /// - Returns: The rendered control group markup from either the true or false content.
    public func render() -> Markup {
        switch storage {
        case .trueContent(let content):
            var content = content
            content.attributes.merge(attributes)
            return content.render()
        case .falseContent(let content):
            var content = content
            content.attributes.merge(attributes)
            return content.render()
        }
    }
}

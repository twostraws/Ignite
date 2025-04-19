//
// HTMLRenderable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the common behavior between Element and InlineElement types.
/// This protocol serves as the foundation for any element that can be rendered as Element.
@MainActor
public protocol RenderableElement: CustomStringConvertible, Sendable {
    /// The standard set of control attributes for Element elements.
    var attributes: CoreAttributes { get set }

    /// Whether this Element belongs to the framework.
    var isPrimitive: Bool { get }

    /// Converts this element and its children into an Element string with attributes.
    /// - Returns: A string containing the rendered Element
    func render() -> String
}

public extension RenderableElement {
    /// The complete string representation of the element.
    nonisolated var description: String {
        MainActor.assumeIsolated {
            self.render()
        }
    }

    /// A collection of styles, classes, and attributes managed by the `AttributeStore` for this element.
    var attributes: CoreAttributes {
        get { CoreAttributes() }
        set {} // swiftlint:disable:this unused_setter_value
    }

    /// The default status as a primitive element.
    var isPrimitive: Bool { false }
}

extension RenderableElement {
    /// The publishing context of this site.
    var publishingContext: PublishingContext {
        PublishingContext.shared
    }

    func `is`(_ elementType: any RenderableElement.Type) -> Bool {
        switch self {
        case let element as any HTML:
            element.isType(elementType)
        case let element as any InlineElement:
            element.isType(elementType)
        default: false
        }
    }

    func `as`<T: RenderableElement>(_ elementType: T.Type) -> T? {
        switch self {
        case let element as any HTML:
            element.asType(elementType)
        case let element as any InlineElement:
            element.asType(elementType)
        default: nil
        }
    }
}

private extension HTML {
    /// Whether this element represents a specific type.
    func isType(_ elementType: any RenderableElement.Type) -> Bool {
        if let anyHTML = body as? AnyHTML {
            type(of: anyHTML.wrapped) == elementType
        } else {
            type(of: body) == elementType
        }
    }

    /// The underlying content, conditionally cast to the specified type.
    func asType<T: RenderableElement>(_ elementType: T.Type) -> T? {
        if let anyHTML = body as? AnyHTML, let element = anyHTML.attributedContent as? T {
            element
        } else if let element = body as? T {
            element
        } else {
            nil
        }
    }
}

private extension InlineElement {
    /// The underlying content, conditionally cast to the specified type.
    func asType<T: RenderableElement>(_ elementType: T.Type) -> T? {
        if let anyHTML = body as? AnyInlineElement, let element = anyHTML.attributedContent as? T {
            element
        } else if let element = body as? T {
            element
        } else {
            nil
        }
    }

    /// Whether this element represents a specific type.
    func isType(_ elementType: any RenderableElement.Type) -> Bool {
        if let anyHTML = body as? AnyInlineElement {
            type(of: anyHTML.wrapped) == elementType
        } else {
            type(of: body) == elementType
        }
    }
}

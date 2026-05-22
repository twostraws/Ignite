//
// HTMLRenderable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the common behavior between all HTML types.
/// - Warning: Do not conform to this type directly.
public protocol MarkupElement {
    /// The standard set of control attributes for HTML elements.
    var attributes: CoreAttributes { get set }

    /// Converts this element and its children into HTML markup.
    /// - Returns: A string containing the HTML markup
    func markup() -> Markup
}

/// A wrapper that should be ignored when inspecting the wrapped element type.
protocol TransparentMarkupWrapper {
    /// The wrapped content, including any attributes added to the wrapper.
    var transparentContent: any MarkupElement { get }
}

extension MarkupElement {
    /// Converts this element and its children into an HTML string with attributes.
    /// - Returns: A string containing the HTML markup
    func markupString() -> String {
        markup().string
    }

    /// The publishing context of this site.
    var publishingContext: PublishingContext {
        PublishingContext.shared
    }

    func `is`(_ elementType: any MarkupElement.Type) -> Bool {
        isType(elementType)
    }

    func `as`<T: MarkupElement>(_ elementType: T.Type) -> T? {
        asType(elementType)
    }
}

private extension MarkupElement {
    /// Whether this element represents a specific type.
    func isType(_ elementType: any MarkupElement.Type) -> Bool {
        if Swift.type(of: self) == elementType {
            true
        } else if let anyHTML = self as? AnyHTML {
            anyHTML.attributedContent.is(elementType)
        } else if let anyHTML = self as? AnyInlineElement {
            anyHTML.attributedContent.is(elementType)
        } else if let wrapper = self as? any TransparentMarkupWrapper {
            wrapper.transparentContent.is(elementType)
        } else if let html = self as? any HTML, html.isPrimitive == false {
            if Swift.type(of: html.body) == Swift.type(of: self) {
                false
            } else {
                html.body.is(elementType)
            }
        } else if let inline = self as? any InlineElement, inline.isPrimitive == false {
            if Swift.type(of: inline.body) == Swift.type(of: self) {
                false
            } else {
                inline.body.is(elementType)
            }
        } else {
            false
        }
    }

    /// The underlying content, conditionally cast to the specified type.
    func asType<T: MarkupElement>(_ elementType: T.Type) -> T? {
        if let element = self as? T {
            element
        } else if let anyHTML = self as? AnyHTML {
            anyHTML.attributedContent.as(elementType)
        } else if let anyHTML = self as? AnyInlineElement {
            anyHTML.attributedContent.as(elementType)
        } else if let wrapper = self as? any TransparentMarkupWrapper {
            wrapper.transparentContent.as(elementType)
        } else if let html = self as? any HTML, html.isPrimitive == false {
            if Swift.type(of: html.body) == Swift.type(of: self) {
                nil
            } else {
                html.body.as(elementType)
            }
        } else if let inline = self as? any InlineElement, inline.isPrimitive == false {
            if Swift.type(of: inline.body) == Swift.type(of: self) {
                nil
            } else {
                inline.body.as(elementType)
            }
        } else {
            nil
        }
    }
}

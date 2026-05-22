//
// StyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct RegisteredStyleHTML: HTML, TransparentMarkupWrapper {
    var body: some HTML { self }
    var attributes = CoreAttributes()
    var isPrimitive: Bool { true }

    let style: any Style
    let content: any HTML

    // This wrapper keeps `.style(MyStyle())` as a normal synchronous HTML modifier,
    // while deferring the publishing-side registration until the element renders.
    // That lets styled elements be constructed before a PublishingContext exists;
    // when markup is generated inside a publish/render context, the style is
    // registered with that specific context's StyleManager.
    var transparentContent: any MarkupElement {
        content.attributes(attributes)
    }

    func markup() -> Markup {
        PublishingContext.current?.styleManager.registerStyle(style)
        return transparentContent.markup()
    }
}

private struct RegisteredStyleInlineElement: InlineElement, TransparentMarkupWrapper {
    var body: some InlineElement { self }
    var attributes = CoreAttributes()
    var isPrimitive: Bool { true }

    let style: any Style
    let content: any InlineElement

    var transparentContent: any MarkupElement {
        content.attributes(attributes)
    }

    func markup() -> Markup {
        PublishingContext.current?.styleManager.registerStyle(style)
        return transparentContent.markup()
    }
}

private func styleModifier(
    _ style: any Style,
    content: any HTML
) -> any HTML {
    RegisteredStyleHTML(style: style, content: content.class(style.className))
}

private func styleModifier(
    _ style: any Style,
    content: any InlineElement
) -> any InlineElement {
    RegisteredStyleInlineElement(style: style, content: content.class(style.className))
}

public extension HTML {
    /// Applies a custom style to the element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the element with the style applied
    func style(_ style: any Style) -> some HTML {
        AnyHTML(styleModifier(style, content: self))
    }
}

public extension InlineElement {
    /// Applies a custom style to the element.
    /// - Parameter style: The style to apply, conforming to the `Style` protocol
    /// - Returns: A modified copy of the element with the style applied
    func style(_ style: any Style) -> some InlineElement {
        AnyInlineElement(styleModifier(style, content: self))
    }
}

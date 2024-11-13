//
// InlineElementBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A result builder that enables declarative syntax for constructing inline HTML elements.
///
/// This builder provides support for creating inline element hierarchies using
/// a SwiftUI-like syntax, handling common control flow patterns like conditionals and loops.
@MainActor
@resultBuilder
public struct InlineElementBuilder {
    /// Converts a single inline element into a builder expression.
    /// - Parameter content: The inline element to convert
    /// - Returns: The same inline element, unchanged
    public static func buildExpression<Content: InlineElement>(_ content: Content) -> Content {
        content
    }
    
    /// Creates an empty HTML element when no content is provided.
    /// - Returns: An empty HTML element
    public static func buildBlock() -> some HTML {
        EmptyHTML()
    }
    
    /// Passes through a single inline element unchanged.
    /// - Parameter content: The inline element to pass through
    /// - Returns: The same inline element
    public static func buildBlock<Content: InlineElement>(_ content: Content) -> Content {
        content
    }
    
    /// Combines two inline elements into a single flattened HTML structure.
    /// - Parameters:
    ///   - c0: The first inline element
    ///   - c1: The second inline element
    /// - Returns: A combined HTML element
    public static func buildBlock<C0: InlineElement, C1: InlineElement>(_ c0: C0, _ c1: C1) -> some HTML {
        FlatHTML([AnyHTML(c0), AnyHTML(c1)])
    }
    
    /// Handles array transformations in the builder.
    /// - Parameter components: Array of inline elements
    /// - Returns: A flattened HTML element
    public static func buildArray<Content: InlineElement>(_ components: [Content]) -> some HTML {
        FlatHTML(components.map { AnyHTML($0) })
    }
    
    /// Handles optional inline elements.
    /// - Parameter component: An optional inline element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: InlineElement>(_ component: Content?) -> some InlineElement {
        if let component {
            return AnyHTML(component)
        }
        return AnyHTML(EmptyHTML())
    }
    
    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The inline element to use if condition is true
    /// - Returns: The provided inline element
    public static func buildEither<Content: InlineElement>(first component: Content) -> Content {
        component
    }
    
    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The inline element to use if condition is false
    /// - Returns: The provided inline element
    public static func buildEither<Content: InlineElement>(second component: Content) -> Content {
        component
    }
    
    /// Handles variadic inline elements by combining them into a flat structure.
    /// - Parameter components: Variable number of inline elements
    /// - Returns: A flattened HTML structure containing all elements
    public static func buildBlock(_ components: any InlineElement...) -> FlatHTML {
        FlatHTML(components)
    }
}

/// Extension providing result builder functionality for combining multiple inline elements
extension InlineElement {
    /// Combines two inline elements into a single element array
    /// - Parameters:
    ///   - c0: First inline element
    ///   - c1: Second inline element
    /// - Returns: Combined array of inline elements
    public static func buildBlock<C0: InlineElement, C1: InlineElement>(
        _ c0: C0,
        _ c1: C1
    ) -> some InlineElement {
        [AnyHTML(c0), AnyHTML(c1)]
    }
    
    /// Combines three inline elements into a single element array
    /// - Parameters:
    ///   - c0: First inline element
    ///   - c1: Second inline element
    ///   - c2: Third inline element
    /// - Returns: Combined array of inline elements
    public static func buildBlock<C0: InlineElement, C1: InlineElement, C2: InlineElement>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2
    ) -> some InlineElement {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2)]
    }
    
    /// Combines four inline elements into a single element array
    /// - Parameters:
    ///   - c0: First inline element
    ///   - c1: Second inline element
    ///   - c2: Third inline element
    ///   - c3: Fourth inline element
    /// - Returns: Combined array of inline elements
    public static func buildBlock<C0: InlineElement, C1: InlineElement, C2: InlineElement, C3: InlineElement>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3
    ) -> some InlineElement {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3)]
    }
    
    /// Combines five inline elements into a single element array
    /// - Parameters:
    ///   - c0: First inline element
    ///   - c1: Second inline element
    ///   - c2: Third inline element
    ///   - c3: Fourth inline element
    ///   - c4: Fifth inline element
    /// - Returns: Combined array of inline elements
    public static func buildBlock<C0: InlineElement, C1: InlineElement, C2: InlineElement, C3: InlineElement, C4: InlineElement>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4
    ) -> some InlineElement {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4)]
    }
    
    /// Combines six inline elements into a single element array
    /// - Parameters:
    ///   - c0: First inline element
    ///   - c1: Second inline element
    ///   - c2: Third inline element
    ///   - c3: Fourth inline element
    ///   - c4: Fifth inline element
    ///   - c5: Sixth inline element
    /// - Returns: Combined array of inline elements
    public static func buildBlock<C0: InlineElement, C1: InlineElement, C2: InlineElement, C3: InlineElement, C4: InlineElement, C5: InlineElement>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5
    ) -> some InlineElement {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4), AnyHTML(c5)]
    }
    
    /// Combines seven inline elements into a single element array
    /// - Parameters:
    ///   - c0: First inline element
    ///   - c1: Second inline element
    ///   - c2: Third inline element
    ///   - c3: Fourth inline element
    ///   - c4: Fifth inline element
    ///   - c5: Sixth inline element
    ///   - c6: Seventh inline element
    /// - Returns: Combined array of inline elements
    public static func buildBlock<C0: InlineElement, C1: InlineElement, C2: InlineElement, C3: InlineElement, C4: InlineElement, C5: InlineElement, C6: InlineElement>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6
    ) -> some InlineElement {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4), AnyHTML(c5), AnyHTML(c6)]
    }
    
    /// Combines eight inline elements into a single element array
    /// - Parameters:
    ///   - c0: First inline element
    ///   - c1: Second inline element
    ///   - c2: Third inline element
    ///   - c3: Fourth inline element
    ///   - c4: Fifth inline element
    ///   - c5: Sixth inline element
    ///   - c6: Seventh inline element
    ///   - c7: Eighth inline element
    /// - Returns: Combined array of inline elements
    public static func buildBlock<C0: InlineElement, C1: InlineElement, C2: InlineElement, C3: InlineElement, C4: InlineElement, C5: InlineElement, C6: InlineElement, C7: InlineElement>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7
    ) -> some InlineElement {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4), AnyHTML(c5), AnyHTML(c6), AnyHTML(c7)]
    }
    
    /// Combines nine inline elements into a single element array
    /// - Parameters:
    ///   - c0: First inline element
    ///   - c1: Second inline element
    ///   - c2: Third inline element
    ///   - c3: Fourth inline element
    ///   - c4: Fifth inline element
    ///   - c5: Sixth inline element
    ///   - c6: Seventh inline element
    ///   - c7: Eighth inline element
    ///   - c8: Ninth inline element
    /// - Returns: Combined array of inline elements
    public static func buildBlock<C0: InlineElement, C1: InlineElement, C2: InlineElement, C3: InlineElement, C4: InlineElement, C5: InlineElement, C6: InlineElement, C7: InlineElement, C8: InlineElement>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7,
        _ c8: C8
    ) -> some InlineElement {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4), AnyHTML(c5), AnyHTML(c6), AnyHTML(c7), AnyHTML(c8)]
    }
}

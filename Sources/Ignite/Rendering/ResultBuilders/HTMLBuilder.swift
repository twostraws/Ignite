//
// HTMLBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A result builder that enables declarative syntax for constructing HTML elements.
///
/// This builder provides support for creating HTML hierarchies using SwiftUI-like syntax,
/// handling common control flow patterns like conditionals, loops, and switch statements.
@MainActor
@resultBuilder
public struct HTMLBuilder {
    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression<Content: HTML>(_ content: Content) -> some HTML {
        content
    }
    
    /// Creates an empty HTML element when no content is provided.
    /// - Returns: An empty HTML element
    public static func buildBlock() -> some HTML {
        EmptyHTML()
    }
    
    /// Passes through a single HTML element unchanged.
    /// - Parameter content: The HTML element to pass through
    /// - Returns: The same HTML element
    public static func buildBlock<Content: HTML>(_ content: Content) -> some HTML {
        content
    }
    
    /// Combines an array of HTML elements into a flat structure.
    /// - Parameter components: Array of HTML elements
    /// - Returns: A flattened HTML structure
    public static func buildBlock(_ components: [any HTML]) -> some HTML {
        FlatHTML(components)
    }
    
    /// Handles array literals in the builder.
    /// - Parameter components: Array of HTML elements
    /// - Returns: A flattened HTML structure
    public static func buildArray(_ components: [any HTML]) -> some HTML {
        FlatHTML(components)
    }
    
    /// Handles optional HTML elements.
    /// - Parameter component: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: HTML>(_ component: Content?) -> some HTML {
        if let component {
            return AnyHTML(component)
        }
        return AnyHTML(EmptyHTML())
    }
    
    /// Handles optional arrays of HTML elements.
    /// - Parameter component: An optional array of HTML elements
    /// - Returns: Either the wrapped elements or an empty element
    public static func buildOptional<Content: HTML>(_ component: [Content]?) -> some HTML {
        if let component {
            return AnyHTML(component)
        }
        return AnyHTML(EmptyHTML())
    }
    
    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is true
    /// - Returns: The wrapped HTML element
    public static func buildEither<Content: HTML>(first component: Content) -> AnyHTML {
        AnyHTML(component)
    }
    
    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is false
    /// - Returns: The wrapped HTML element
    public static func buildEither<Content: HTML>(second component: Content) -> AnyHTML {
        AnyHTML(component)
    }
    
    /// Handles optional content in if statements.
    /// - Parameter component: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildIf<Content: HTML>(_ component: Content?) -> AnyHTML {
        if let component {
            return AnyHTML(component)
        }
        return AnyHTML(EmptyHTML())
    }
    
    /// Handles array transformations in the builder.
    /// - Parameter components: Array of HTML elements
    /// - Returns: The same array as HTML content
    public static func buildArray<Content: HTML>(_ components: [Content]) -> some HTML {
        components
    }
    
    /// Handles nested arrays from loops and other control flow.
    /// - Parameter components: Variadic array of HTML element arrays
    /// - Returns: A flattened HTML structure
    public static func buildBlock(_ components: [any HTML]...) -> some HTML {
        FlatHTML(components.flatMap { $0 })
    }
    
    /// Converts text content into HTML.
    /// - Parameter text: The text to convert
    /// - Returns: Text wrapped as HTML
    public static func buildExpression(_ text: Text) -> some HTML {
        text
    }
    
    /// Handles inline elements that conform to HTML protocol.
    /// - Parameter content: The inline HTML element
    /// - Returns: The same element unchanged
    public static func buildExpression<Content: HTML & InlineElement>(_ content: Content) -> some HTML {
        content
    }
    
    /// Handles availability conditions in switch statements.
    /// - Parameter component: The HTML element to conditionally include
    /// - Returns: The same HTML element unchanged
    public static func buildLimitedAvailability(_ component: some HTML) -> some HTML {
        component
    }
    
    /// Handles nested arrays of HTML elements.
    /// - Parameter components: Two-dimensional array of HTML elements
    /// - Returns: A flattened HTML structure
    public static func buildArray(_ components: [[any HTML]]) -> some HTML {
        FlatHTML(components.flatMap { $0 })
    }
    
    /// Handles optional content in if let statements.
    /// - Parameter content: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildBlock<Content: HTML>(_ content: Content?) -> some HTML {
        if let content {
            return AnyHTML(content)
        }
        return AnyHTML(EmptyHTML())
    }
    
    /// Handles multiple optional conditions in nested if let statements.
    /// - Parameter components: Variadic array of optional HTML elements
    /// - Returns: A flattened HTML structure containing non-nil elements
    public static func buildBlock<Content: HTML>(_ components: (any HTML)?...) -> some HTML {
        FlatHTML(components.compactMap { $0 })
    }
}

/// Extension providing result builder functionality for combining multiple HTML elements
extension HTMLBuilder {
    /// Combines two HTML elements into a single element array
    /// - Parameters:
    ///   - c0: First HTML element
    ///   - c1: Second HTML element
    /// - Returns: Combined array of HTML elements
    public static func buildBlock<C0: HTML, C1: HTML>(
        _ c0: C0,
        _ c1: C1
    ) -> some HTML {
        [AnyHTML(c0), AnyHTML(c1)]
    }
    
    /// Combines three HTML elements into a single element array
    /// - Parameters:
    ///   - c0: First HTML element
    ///   - c1: Second HTML element
    ///   - c2: Third HTML element
    /// - Returns: Combined array of HTML elements
    public static func buildBlock<C0: HTML, C1: HTML, C2: HTML>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2
    ) -> some HTML {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2)]
    }
    
    /// Combines four HTML elements into a single element array
    /// - Parameters:
    ///   - c0: First HTML element
    ///   - c1: Second HTML element
    ///   - c2: Third HTML element
    ///   - c3: Fourth HTML element
    /// - Returns: Combined array of HTML elements
    public static func buildBlock<C0: HTML, C1: HTML, C2: HTML, C3: HTML>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3
    ) -> some HTML {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3)]
    }
    
    /// Combines five HTML elements into a single element array
    /// - Parameters:
    ///   - c0: First HTML element
    ///   - c1: Second HTML element
    ///   - c2: Third HTML element
    ///   - c3: Fourth HTML element
    ///   - c4: Fifth HTML element
    /// - Returns: Combined array of HTML elements
    public static func buildBlock<C0: HTML, C1: HTML, C2: HTML, C3: HTML, C4: HTML>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4
    ) -> some HTML {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4)]
    }
    
    /// Combines six HTML elements into a single element array
    /// - Parameters:
    ///   - c0: First HTML element
    ///   - c1: Second HTML element
    ///   - c2: Third HTML element
    ///   - c3: Fourth HTML element
    ///   - c4: Fifth HTML element
    ///   - c5: Sixth HTML element
    /// - Returns: Combined array of HTML elements
    public static func buildBlock<C0: HTML, C1: HTML, C2: HTML, C3: HTML, C4: HTML, C5: HTML>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5
    ) -> some HTML {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4), AnyHTML(c5)]
    }
    
    /// Combines seven HTML elements into a single element array
    /// - Parameters:
    ///   - c0: First HTML element
    ///   - c1: Second HTML element
    ///   - c2: Third HTML element
    ///   - c3: Fourth HTML element
    ///   - c4: Fifth HTML element
    ///   - c5: Sixth HTML element
    ///   - c6: Seventh HTML element
    /// - Returns: Combined array of HTML elements
    public static func buildBlock<C0: HTML, C1: HTML, C2: HTML, C3: HTML, C4: HTML, C5: HTML, C6: HTML>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6
    ) -> some HTML {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4), AnyHTML(c5), AnyHTML(c6)]
    }
    
    /// Combines eight HTML elements into a single element array
    /// - Parameters:
    ///   - c0: First HTML element
    ///   - c1: Second HTML element
    ///   - c2: Third HTML element
    ///   - c3: Fourth HTML element
    ///   - c4: Fifth HTML element
    ///   - c5: Sixth HTML element
    ///   - c6: Seventh HTML element
    ///   - c7: Eighth HTML element
    /// - Returns: Combined array of HTML elements
    public static func buildBlock<C0: HTML, C1: HTML, C2: HTML, C3: HTML, C4: HTML, C5: HTML, C6: HTML, C7: HTML>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7
    ) -> some HTML {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4), AnyHTML(c5), AnyHTML(c6), AnyHTML(c7)]
    }
    
    /// Combines nine HTML elements into a single element array
    /// - Parameters:
    ///   - c0: First HTML element
    ///   - c1: Second HTML element
    ///   - c2: Third HTML element
    ///   - c3: Fourth HTML element
    ///   - c4: Fifth HTML element
    ///   - c5: Sixth HTML element
    ///   - c6: Seventh HTML element
    ///   - c7: Eighth HTML element
    ///   - c8: Ninth HTML element
    /// - Returns: Combined array of HTML elements
    public static func buildBlock<C0: HTML, C1: HTML, C2: HTML, C3: HTML, C4: HTML, C5: HTML, C6: HTML, C7: HTML, C8: HTML>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7,
        _ c8: C8
    ) -> some HTML {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2), AnyHTML(c3), AnyHTML(c4), AnyHTML(c5), AnyHTML(c6), AnyHTML(c7), AnyHTML(c8)]
    }
}

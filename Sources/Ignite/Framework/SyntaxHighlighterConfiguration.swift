//
// SyntaxHighlighterConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Configuration for syntax highlighting behavior in code blocks.
public struct SyntaxHighlighterConfiguration: Sendable {
    /// Controls the visibility and formatting of line numbers.
    public enum LineNumberVisibility: Sendable {
        /// Shows line numbers with the specified starting number and wrapping behavior.
        case visible(firstLine: Int, linesWrap: Bool)
        /// Hides line numbers.
        case hidden

        /// Shows line numbers starting at 1 without text wrapping.
        public static let visible: Self = .visible(firstLine: 1, linesWrap: false)
    }

    /// The programming languages to enable syntax highlighting for.
    var languages: [HighlighterLanguage]

    /// Whether and how to display line numbers.
    var lineNumberVisibility: LineNumberVisibility

    /// The number to start counting from when showing line numbers.
    var firstLineNumber: Int

    /// Whether long lines should wrap to the next line.
    var shouldWrapLines: Bool

    /// Default configuration that automatically detects languages.
    public static let automatic: Self = .init(languages: [])

    /// Creates a new syntax highlighter configuration.
    /// - Parameters:
    ///   - languages: The programming languages to enable highlighting for.
    ///   - lineNumberVisibility: Whether and how to display line numbers.
    ///   - firstLineNumber: The number to start counting from when showing line numbers.
    ///   - shouldWrapLines: Whether long lines should wrap to the next line.
    public init(
        languages: [HighlighterLanguage],
        lineNumberVisibility: LineNumberVisibility = .hidden,
        firstLineNumber: Int = 1,
        shouldWrapLines: Bool = false
    ) {
        self.languages = languages
        self.lineNumberVisibility = lineNumberVisibility
        self.firstLineNumber = firstLineNumber
        self.shouldWrapLines = shouldWrapLines
    }
}

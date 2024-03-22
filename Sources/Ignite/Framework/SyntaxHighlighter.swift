//
// SyntaxHighlighter.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// The collection of syntax highlighters supported by Ignite.
public enum SyntaxHighlighter: String {
    case appleScript
    case bash
    case c // swiftlint:disable:this identifier_name
    case cLike
    case cPlusPlus
    case cSharp
    case css
    case dart
    case git
    case go // swiftlint:disable:this identifier_name
    case html
    case java
    case javaScript
    case json
    case kotlin
    case markdown
    case markup
    case markupTemplating
    case objectiveC
    case perl
    case php
    case python
    case ruby
    case rust
    case sql
    case swift
    case typeScript
    case webAssembly
    case yaml

    var dependency: SyntaxHighlighter? {
        switch self {
        case .c: .cLike
        case .cPlusPlus: .c
        case .cSharp: .cLike
        case .dart: .cLike
        case .go: .cLike
        case .java: .cLike
        case .javaScript: .cLike
        case .kotlin: .cLike
        case .markdown: .markup
        case .objectiveC: .c
        case .ruby: .cLike
        case .typeScript: .javaScript
        default: nil
        }
    }

    var files: [String] {
        var result = ["prism-core.js"]

        if let dependency {
            result.append("\(dependency.rawValue).js")
        }

        result.append("\(self.rawValue).js")
        return result
    }
}

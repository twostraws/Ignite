//
// SyntaxHighlighter.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The collection of syntax highlighters supported by Ignite.
public enum HighlighterLanguage: String, Sendable {
    case appleScript = "applescript"
    case bash = "bash"
    case c = "c" // swiftlint:disable:this identifier_name
    case cLike = "c-like"
    case cPlusPlus = "cpp"
    case cSharp = "csharp"
    case css = "css"
    case dart = "dart"
    case git = "git"
    case go = "go" // swiftlint:disable:this identifier_name
    case html = "html"
    case java = "java"
    case javaScript = "javascript"
    case json = "json"
    case kotlin = "kotlin"
    case markdown = "markdown"
    case markup = "xml"
    case markupTemplating = "template"
    case objectiveC = "objectivec"
    case perl = "perl"
    case php = "php"
    case python = "python"
    case ruby = "ruby"
    case rust = "rust"
    case sql = "sql"
    case swift = "swift"
    case typeScript = "typescript"
    case webAssembly = "wasm"
    case yaml = "yaml"
}

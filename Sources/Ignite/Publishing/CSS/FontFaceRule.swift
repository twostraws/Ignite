//
// FontFace.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents a CSS @font-face rule
struct FontFaceRule: Hashable, Equatable, Sendable {
    let family: String
    let source: URL
    let weight: String
    let style: String
    let display: String

    init(
        family: String,
        source: URL,
        weight: String = "normal",
        style: String = "normal",
        display: String = "swap"
    ) {
        self.family = family
        self.source = source
        self.weight = weight
        self.style = style
        self.display = display
    }

    func render() -> String {
        """
        @font-face {
            font-family: '\(family)';
            src: url('\(source.absoluteString)');
            font-weight: \(weight);
            font-style: \(style);
            font-display: \(display);
        }
        """
    }
}

extension FontFaceRule: CustomStringConvertible {
    var description: String {
        render()
    }
}

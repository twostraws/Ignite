//
// FontStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A style that applies font properties to `HTML` elements by converting a `Font` into CSS styles.
struct FontStyle: Style {
    /// The font configuration to be converted into CSS styles.
    let font: Font

    /// Creates a new font style from the given font configuration.
    init(_ font: Font) {
        self.font = font
    }

    var body: some Style {
        if let name = font.name {
            BasicStyle(.fontFamily, value: name)
        }
        if let size = font.size {
            BasicStyle(.fontSize, value: size)
        }
        if let level = font.style {
            BasicStyle(.fontSize, value: level.sizeVariable)
        }
        BasicStyle(.fontWeight, value: font.weight.rawValue)
    }
}

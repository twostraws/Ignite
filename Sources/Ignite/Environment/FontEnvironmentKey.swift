//
// EnvironmentValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct FontKey: EnvironmentKey {
    public static var defaultValue: Font = .body
}

extension EnvironmentValues {
    var font: Font {
        get {
            self.values[\EnvironmentValues.font] as? Font ?? .body
        }
        set {
            self.values[\EnvironmentValues.font] = newValue
        }
    }
}

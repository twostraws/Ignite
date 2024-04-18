//
// PublishingContextKey.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

struct PublishingContextKey: EnvironmentKey {
    static let defaultValue = PublishingContext.empty
}

extension EnvironmentValues {
    public var context: PublishingContext {
        get { self[PublishingContextKey.self] }
        set { self[PublishingContextKey.self] = newValue }
    }
}

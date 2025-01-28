//
// Context.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
@testable import Ignite

@MainActor
@propertyWrapper
public struct SiteDependent<Value: HTML> {
    private let site: any Site
    private var value: Value

    public var wrappedValue: Value {
        get {
            try! PublishingContext.initialize(for: site, from: #filePath)
            return value
        }
        set {
            value = newValue
        }
    }

    public init(wrappedValue: Value, _ site: any Site) {
        self.site = site
        self.value = wrappedValue
        try! PublishingContext.initialize(for: site, from: #filePath)
    }
}

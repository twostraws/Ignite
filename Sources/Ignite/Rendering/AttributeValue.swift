//
// AttributeValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A simple key-value pair of strings that is able to store custom attributes.
public struct AttributeValue {
    /// The attribute's name, e.g. "target" or "rel".
    var name: String

    /// The attribute's value, e.g. "myFrame" or "stylesheet".
    var value: String
}

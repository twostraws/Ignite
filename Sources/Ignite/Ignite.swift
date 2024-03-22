//
// Ignite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//
import Foundation

/// A handful of shared values useful for using the Ignite framework.
public struct Ignite {
    /// The location the the Ignite bundle. Used to access resources.
    public static var bundle: Bundle { Bundle.module }

    /// The current version. Used to write generator information.
    public static var version = "Ignite v0.1.0"
}

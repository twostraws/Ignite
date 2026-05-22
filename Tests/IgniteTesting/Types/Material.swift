//
//  Material.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Material` type.
@Suite("Material Tests")
struct MaterialTests {
    @Test("Correct class name without color scheme.", .publishingContext(), arguments: [
        (Material.ultraThinMaterial, "ultra-thin"),
        (Material.thinMaterial, "thin"),
        (Material.regularMaterial, "regular"),
        (Material.thickMaterial, "thick"),
        (Material.ultraThickMaterial, "ultra-thick")
    ])

    func className(material: Material, type: String) async throws {
        #expect(material.className == "material-\(type)")
    }

    @Test("Correct class name with color scheme.", .publishingContext(), arguments: [
        (Material.ultraThinMaterial, ColorScheme.dark, "ultra-thin"),
        (Material.thinMaterial, ColorScheme.dark, "thin"),
        (Material.regularMaterial, ColorScheme.dark, "regular"),
        (Material.thickMaterial, ColorScheme.dark, "thick"),
        (Material.ultraThickMaterial, ColorScheme.dark, "ultra-thick"),
        (Material.ultraThinMaterial, ColorScheme.light, "ultra-thin"),
        (Material.thinMaterial, ColorScheme.light, "thin"),
        (Material.regularMaterial, ColorScheme.light, "regular"),
        (Material.thickMaterial, ColorScheme.light, "thick"),
        (Material.ultraThickMaterial, ColorScheme.light, "ultra-thick")
    ])

    func className(material: Material, colorScheme: ColorScheme, type: String) async throws {
        let colorSchemeMaterial = material.colorScheme(colorScheme)
        #expect(colorSchemeMaterial.className == "material-\(type)-\(colorScheme.rawValue)")
    }
}

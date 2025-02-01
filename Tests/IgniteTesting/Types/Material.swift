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
@MainActor
struct MaterialTests {
    @Test("Correct class name without color scheme.", arguments: await [
        (Material.ultraThinMaterial, "ultra-thin"),
        (Material.thinMaterial, "thin"),
        (Material.regularMaterial, "regular"),
        (Material.thickMaterial, "thick"),
        (Material.ultraThickMaterial, "ultra-thick")
    ])

    func className(material: Material, type: String) async throws {
        #expect(material.className == "material-\(type)")
    }

    @Test("Correct class name with color scheme.", arguments: await [
        (Material.ultraThinMaterial, Material.ColorScheme.dark, "ultra-thin"),
        (Material.thinMaterial, Material.ColorScheme.dark, "thin"),
        (Material.regularMaterial, Material.ColorScheme.dark, "regular"),
        (Material.thickMaterial, Material.ColorScheme.dark, "thick"),
        (Material.ultraThickMaterial, Material.ColorScheme.dark, "ultra-thick"),
        (Material.ultraThinMaterial, Material.ColorScheme.light, "ultra-thin"),
        (Material.thinMaterial, Material.ColorScheme.light, "thin"),
        (Material.regularMaterial, Material.ColorScheme.light, "regular"),
        (Material.thickMaterial, Material.ColorScheme.light, "thick"),
        (Material.ultraThickMaterial, Material.ColorScheme.light, "ultra-thick")
    ])

    func className(material: Material, colorScheme: Material.ColorScheme, type: String) async throws {
        let colorSchemeMaterial = material.colorScheme(colorScheme)
        #expect(colorSchemeMaterial.className == "material-\(type)-\(colorScheme.rawValue)")
    }
}

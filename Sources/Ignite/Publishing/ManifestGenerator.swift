//
// ManifestGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

struct ManifestGenerator {
    var site: any Site
    
    func generateManifest() -> String {
        
        let manifest = Manifest(name: "\(site.name)",
                                short_name: "\(site.shortName ?? "")",
                                start_url: "/?source=pwa",
                                display: "standalone",
                                background_color: site.backgroundColor!.hex,
                                theme_color: site.themeColor!.hex,
                                description: site.description,
                                categories: site.categories,
                                language: site.language.rawValue,
                                id: "/?source=pwa",
                                scope: "/",
                                orientation: "any",
                                icons: site.icons)
        
        do {
            let jsonData = try JSONEncoder().encode(manifest)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error encoding manifest: \(error)")
        }
        
      return ""
    }
}

struct Manifest: Codable {
    let name: String
    let short_name: String
    let start_url: String
    let display: String
    let background_color: String?
    let theme_color: String?
    let description: String?
    let categories: [String?]
    let language: String
    let id: String
    let scope: String
    let orientation: String
    let icons: [Icon?]
}

public struct Icon: Codable {
    let src: String
    let sizes: String
    let type: String
}

//
// SocialIcon.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
// Created by joshua kaunert on 6/14/24.
//

import Foundation

/// represents a single social icon
public struct SocialIcon {
    /// name of built-in icon (Built-in icons must be enabled)
    /// see https://icons.getbootstrap.com/?q=social for complete list
    let iconName: String
    /// the url target
    let targetURL: String
    /// location of image file if not using built-in
    let customImageURL: String?
    
    /// computed property, returns either built-in image, or custom image if passed a `customImageURL`
    var image: Image {
        if let imageURL = customImageURL {
            Image(decorative: imageURL)
                .frame(width: 32)
                .resizable()
                .opacity(0.74)
                .foregroundStyle(.secondary)
        } else {
            Image(systemName: iconName)
                .opacity(0.74)
        }
    }
    
    public init(name: String, targetURL: String, customImageURL: String? = nil) {
        self.iconName = name
        self.targetURL = targetURL
        self.customImageURL = customImageURL
    }
}

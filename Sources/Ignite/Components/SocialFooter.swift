//
// SocialFooter.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
// Created by joshua kaunert on 6/14/24.
//

import Foundation

/// Displays "Social Footer", with each icon opening an external social site in a new browser tab.
public struct SocialFooter: Component {
    /// the array of `Links` to use in the social footer, populated using an array of `SocialIcons` passed into initializer
    var links: [Link] = []
    
    /// Initializer constructs `Link`s from user provided array of `SocialIcon`s and appends each to `links` array
    public init(_ icons: [SocialIcon]) {
        for icon in icons {
            links.append(
                Link(icon.image, target: icon.targetURL)
                    .target(.blank)
                    .relationship(.noOpener, .noReferrer)
                    .margin(.trailing, 20)
                    .role(.secondary)
            )
        }
    }

    public func body(context: PublishingContext) -> [any PageElement] {
        
        Text {
            /// Iterates over `links` and adds each link to the `Text` element
            for link in links {
                link
            }
        }
        .font(.title2)
        .horizontalAlignment(.center)
        .margin(.top, .extraLarge)
    }
}

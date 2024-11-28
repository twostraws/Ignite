//
// Spacer.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Creates vertical space of a specific value.
public struct Spacer: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The amount of vertical space this `Spacer` occupies, specified as a
    /// `SpacingAmount` value. If this is nil, the `size` integer will be
    /// used instead.
    var spacingAmount: SpacingAmount?

    /// The amount of vertical space this `Spacer` occupies.
    var size: Int

    /// Creates a new `Spacer` with a size in pixels of your choosing.
    /// Defaults to 20.
    /// - Parameter size: The amount of vertical space this `Spacer`
    /// should occupy. Defaults to 20.
    public init(size: Int = 20) {
        self.size = size
    }

    /// Creates a new `Spacer` using adaptive sizing.
    /// - Parameter size: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    public init(size: SpacingAmount) {
        self.spacingAmount = size
        self.size = 0
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        if let spacingAmount {
            Group {}
                .margin(.top, spacingAmount)
                .render(context: context)
        } else {
            Group {}
                .frame(height: size)
                .render(context: context)
        }
    }
}

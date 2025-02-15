//
// Spacer.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates vertical space of a specific value.
public struct Spacer: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    /// The amount of space to occupy.
    var spacingAmount: SpacingType

    /// Creates a new `Spacer` with a size in pixels of your choosing.
    /// Defaults to 20.
    /// - Parameter size: The amount of vertical space this `Spacer`
    /// should occupy. Defaults to 20.
    public init(size: Int = 20) {
        spacingAmount = .exact(size)
    }

    /// Creates a new `Spacer` using adaptive sizing.
    /// - Parameter size: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    public init(size: SpacingAmount) {
        spacingAmount = .semantic(size)
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        if case let .semantic(spacingAmount) = spacingAmount {
            Section {}
                .margin(.top, spacingAmount)
                .render()
        } else if case let .exact(int) = spacingAmount {
            Section {}
                .frame(height: .px(int))
                .render()
        } else {
            fatalError("Unknown spacing amount: \(String(describing: spacingAmount))")
        }
    }
}

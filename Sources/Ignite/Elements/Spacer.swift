//
// Spacer.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates vertical space of a specific value.
public struct Spacer: HTML, NavigationItem {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The amount of space to occupy.
    var spacingAmount: SpacingType

    /// Whether the spacing should be applied horizontally or vertically.
    var axis: Axis = .vertical

    /// Controls whether this dropdown needs to be created as its own element,
    /// or whether it uses the structure provided by a parent `NavigationBar`.
    var isNavigationItem = false

    /// Creates a new `Spacer` with a size
    /// automatically determined by the context.
    public init() {
        spacingAmount = .automatic
    }

    /// Creates a new `Spacer` with a size in pixels of your choosing.
    /// - Parameter size: The amount of vertical space this `Spacer`
    /// should occupy.
    public init(size: Int) {
        spacingAmount = .exact(size)
    }

    /// Creates a new `Spacer` using adaptive sizing.
    /// - Parameter size: The amount of margin to apply, specified as a
    /// `SpacingAmount` case.
    public init(size: SpacingAmount) {
        spacingAmount = .semantic(size)
    }

    /// Configures this dropdown to be placed inside a `NavigationBar`.
    /// - Returns: A new `Spacer` instance suitable for placement
    /// inside a `NavigationBar`.
    func configuredAsNavigationItem(_ isNavItem: Bool) -> Self {
        var copy = self
        copy.isNavigationItem = isNavItem
        copy.axis = .horizontal
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        if spacingAmount == .automatic {
            Section {}
                .frame(width: axis == .horizontal && !isNavigationItem ? .px(20) : nil)
                .frame(height: axis == .vertical ? .px(20) : nil)
                .class("ms-auto")
                .markup()
        } else if case let .semantic(spacingAmount) = spacingAmount {
            Section {}
                .margin(axis == .vertical ? .top : .leading, spacingAmount)
                .markup()
        } else if case let .exact(int) = spacingAmount {
            Section {}
                .frame(width: axis == .horizontal ? .px(int) : nil)
                .frame(height: axis == .vertical ? .px(int) : nil)
                .markup()
        } else {
            fatalError("Unknown spacing amount: \(String(describing: spacingAmount))")
        }
    }
}

extension Spacer: NavigationItemConfigurable {}

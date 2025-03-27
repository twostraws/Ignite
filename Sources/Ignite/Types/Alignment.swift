//
// Alignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An alignment in both axes.
@MainActor
public struct Alignment: Equatable {
    /// The alignment on the horizontal axis.
    public let horizontal: HorizontalAlignment

    /// The alignment on the vertical axis.
    public let vertical: VerticalAlignment

    /// Creates a custom alignment value with the specified horizontal and vertical alignment guides.
    public init(horizontal: HorizontalAlignment = .center, vertical: VerticalAlignment = .center) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    /// A guide that marks the top and leading edges.
    public static let topLeading = Alignment(horizontal: .leading, vertical: .top)

    /// A guide that marks the top edge.
    public static let top = Alignment(horizontal: .center, vertical: .top)

    /// A guide that marks the top and trailing edges.
    public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)

    /// A guide that marks the leading edge.
    public static let leading = Alignment(horizontal: .leading, vertical: .center)

    /// A guide that marks the center.
    public static let center = Alignment(horizontal: .center, vertical: .center)

    /// A guide that marks the trailing edge.
    public static let trailing = Alignment(horizontal: .trailing, vertical: .center)

    /// A guide that marks the bottom and leading edges.
    public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)

    /// A guide that marks the bottom edge.
    public static let bottom = Alignment(horizontal: .center, vertical: .bottom)

    /// A guide that marks the bottom and trailing edges.
    public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)
}

extension Alignment {
    /// The appropriate Bootstrap classes for this alignment
    var bootstrapClasses: [String] {
        [horizontal.containerAlignmentClass, vertical.containerAlignmentClass]
    }

    /// Flex container rules for aligning content
    var flexAlignmentRules: [InlineStyle] {
        switch (horizontal, vertical) {
        case (.leading, .top): [.init(.alignItems, value: "flex-start"), .init(.justifyContent, value: "flex-start")]
        case (.center, .top): [.init(.alignItems, value: "center"), .init(.justifyContent, value: "flex-start")]
        case (.trailing, .top): [.init(.alignItems, value: "flex-end"), .init(.justifyContent, value: "flex-start")]
        case (.leading, .center): [.init(.alignItems, value: "flex-start"), .init(.justifyContent, value: "center")]
        case (.center, .center): [.init(.alignItems, value: "center"), .init(.justifyContent, value: "center")]
        case (.trailing, .center): [.init(.alignItems, value: "flex-end"), .init(.justifyContent, value: "center")]
        case (.leading, .bottom): [.init(.alignItems, value: "flex-start"), .init(.justifyContent, value: "flex-end")]
        case (.center, .bottom): [.init(.alignItems, value: "center"), .init(.justifyContent, value: "flex-end")]
        case (.trailing, .bottom): [.init(.alignItems, value: "flex-end"), .init(.justifyContent, value: "flex-end")]
        }
    }

    /// Alignment rules for the items of containers
    var itemAlignmentRules: [InlineStyle] {
        switch (horizontal, vertical) {
        case (.leading, .top):      [.init(.alignSelf, value: "flex-start"), .init(.justifySelf, value: "flex-start")]
        case (.center, .top):       [.init(.alignSelf, value: "flex-start"), .init(.justifySelf, value: "center")]
        case (.trailing, .top):     [.init(.alignSelf, value: "flex-start"), .init(.justifySelf, value: "flex-end")]
        case (.leading, .center):   [.init(.alignSelf, value: "center"), .init(.justifySelf, value: "flex-start")]
        case (.center, .center):    [.init(.alignSelf, value: "center"), .init(.justifySelf, value: "center")]
        case (.trailing, .center):  [.init(.alignSelf, value: "center"), .init(.justifySelf, value: "flex-end")]
        case (.leading, .bottom):   [.init(.alignSelf, value: "flex-end"), .init(.justifySelf, value: "flex-start")]
        case (.center, .bottom):    [.init(.alignSelf, value: "flex-end"), .init(.justifySelf, value: "center")]
        case (.trailing, .bottom):  [.init(.alignSelf, value: "flex-end"), .init(.justifySelf, value: "flex-end")]
        }
    }
}

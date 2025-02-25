//
// BackgroundImage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Applies a background image to the element.
    /// - Parameters:
    ///   - image: The path to the image
    ///   - contentMode: How the image should be sized
    ///   - position: The position of the image within the element
    ///   - repeats: Whether the image should be repeated
    /// - Returns: A modified element with the background image applied
    func background(
        image: String,
        contentMode: BackgroundImageContentMode,
        position: BackgroundPosition = .center,
        repeats: Bool = false
    ) -> some HTML {
        self.style(
            .init(.backgroundImage, value: "url('\(image)')"),
            .init(.backgroundSize, value: contentMode.css),
            .init(.backgroundRepeat, value: repeats ? "repeat" : "no-repeat"),
            .init(.backgroundPosition, value: position.css)
        )
    }
}

protocol CSSRepresentable {
    var css: String { get }
}

/// The possible background sizes
public enum BackgroundImageContentMode: CSSRepresentable, Sendable {
    /// This is the default value. The background image is displayed at its original size.
    case original

    /// Scales the background image to cover the entire container while maintaining its aspect ratio.
    case fill

    /// Scales the background image to fit within the container without
    case fit

    /// The exact width and height using length values (pixels, ems, percentages, auto etc.)
    case size(width: String, height: String)

    /// The CSS name of the size.
    var css: String {
        switch self {
        case .original: "auto"
        case .fill: "cover"
        case .fit: "contain"
        case .size(let width, let height): "\(width) \(height)"
        }
    }
}

/// A type representing the background image position within the page element
public struct BackgroundPosition: CSSRepresentable, Sendable {

    /// The possible absolute values going from left to right and top to bottom.
    /// For example an offset from the top edge of `10px` means 10 px down from the top.
    /// Likewise an offset from the top edge of 50% means down 50 % of the total height.
    /// Calculation can be made using calc, e.g. calc(50% + 100px) means centered plus 100px.
    public enum Value: CSSRepresentable {
        case pixel(_ value: Int)
        case percent(_ value: Int)

        public static var zero: Self { .percent(0) }

        /// The css description of the offset
        var css: String {
            switch self {
            case .pixel(let value): "\(value)px"
            case .percent(let value): "\(value)%"
            }
        }
    }

    /// The possible horizontal alignment values.
    public enum HorizontalAlignment: CSSRepresentable {
        case leading, center, trailing, absolute(Value)

        /// The CSS name of the alignment.
        var css: String {
            switch self {
            case .leading: "left"
            case .center: "center"
            case .trailing: "right"
            case .absolute(let value): value.css
            }
        }

        /// Returns the CSS description of the alignment as a value.
        static func value(for alignment: HorizontalAlignment) -> Value {
            switch alignment {
            case .leading: .percent(0)
            case .center: .percent(50)
            case .trailing: .percent(100)
            case .absolute(let value): value
            }
        }
    }

    /// The possible vertical alignment values.
    public enum VerticalAlignment: CSSRepresentable {
        case top, center, bottom, absolute(Value)

        /// The CSS name of the alignment.
        var css: String {
            switch self {
            case .top: "top"
            case .center: "center"
            case .bottom: "bottom"
            case .absolute(let value): value.css
            }
        }

        /// Returns the CSS description of the alignment as a value.
        static func value(for alignment: VerticalAlignment) -> Value {
            switch alignment {
            case .top: .percent(0)
            case .center: .percent(50)
            case .bottom: .percent(100)
            case .absolute(let value): value
            }
        }
    }

    /// Positions the image at the center.
    public static var center: Self { .init() }

    /// Positions the image at the top and centered horizontally.
    public static var top: Self { .init(vertical: .top) }

    /// Positions the image at the bottom and centered horizontally.
    public static var bottom: Self { .init(vertical: .bottom)}

    /// Positions the image on the leading edge and centered vertically.
    public static var leading: Self { .init(horizontal: .leading)}

    /// Positions the image on the trailing edge and centered vertically.
    public static var trailing: Self { .init(horizontal: .trailing) }

    /// Positions the image at the top leading edge.
    public static var topLeading: Self { .init(vertical: .top, horizontal: .leading) }

    /// Positions the image at the top trailing edge.
    public static var topTrailing: Self { .init(vertical: .top, horizontal: .trailing)}

    /// Positions the image on the bottom leading edge.
    public static var bottomLeading: Self { .init(vertical: .bottom, horizontal: .leading)}

    /// Positions the image on the bottom trailing edge.
    public static var bottomTrailing: Self { .init(vertical: .bottom, horizontal: .trailing) }

    /// Positions the image relative to a vertical and horizontal alignment.
    public static func position(
        vertical: Value, relativeTo verticalAlignment: VerticalAlignment,
        horizontal: Value, relativeTo horizontalAlignment: HorizontalAlignment
    ) -> Self {
        .init(
            verticalPosition: "calc(\(VerticalAlignment.value(for: verticalAlignment).css) + \(vertical.css))",
            horizontalPosition: "calc(\(HorizontalAlignment.value(for: horizontalAlignment).css) + \(horizontal.css))"
        )
    }

    /// The CSS representation of the background image position.
    var css: String {
        [horizontalPosition, verticalPosition].joined(separator: " ")
    }

    private let verticalPosition: String
    private let horizontalPosition: String

    init(vertical: VerticalAlignment = .center, horizontal: HorizontalAlignment = .center) {
        self.horizontalPosition = horizontal.css
        self.verticalPosition = vertical.css
    }

    private init(verticalPosition: String, horizontalPosition: String) {
        self.verticalPosition = verticalPosition
        self.horizontalPosition = horizontalPosition
    }
}

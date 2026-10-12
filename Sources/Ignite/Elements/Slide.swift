//
// Slide.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// One slide in a `Carousel`.
public struct Slide: HTML {
    /// Defines how an image should fit within its container.
    public enum ImageFit: String {
        /// Scale image to completely fill container, may crop edges.
        case cover

        /// Scale image to fit entirely within container, preserving aspect ratio (default).
        case contain

        /// Stretch image to fill container, may distort aspect ratio.
        case fill

        /// Display image at original size or scaled down if larger than container.
        case scaleDown = "scale-down"

        /// Display image at original size.
        case none
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// An optional background image to use for this slide. This should be
    /// specified relative to the root of your site, e.g. /images/dog.jpg.
    var background: String?

    /// Other items to display inside this slide.
    var items: HTMLCollection

    /// How opaque the background image should be. Use values lower than 1.0
    /// to progressively dim the background image.
    var backgroundOpacity = 1.0

    /// How the background image should fit within the slide container.
    var imageFit: ImageFit = .contain

    /// The background color for the slide container, used for letterboxing
    /// when the image does not fill the entire space.
    var containerBackgroundColor: String = "transparent"

    /// Creates a new `Slide` object using a background image.
    /// - Parameters:
    ///   - background: An optional background image to use for this slide.
    ///     This should be specified relative to the root of your site, e.g. /images/dog.jpg.
    ///   - imageFit: How the image should fit within the container. Default is `.contain`.
    ///   - backgroundColor: Background color for letterboxing areas. Default is "transparent".
    public init(
        background: String,
        imageFit: ImageFit = .contain,
        backgroundColor: String = "transparent"
    ) {
        self.background = background
        self.items = HTMLCollection([])
        self.imageFit = imageFit
        self.containerBackgroundColor = backgroundColor
    }

    /// Creates a new `Slide` object using a background image and a page
    /// element builder that returns an array of `HTML` objects to use
    /// inside the slide.
    /// - Parameters:
    ///   - background: An optional background image to use for this slide.
    ///     This should be specified relative to the root of your site, e.g. /images/dog.jpg.
    ///   - imageFit: How the image should fit within the container. Default is `.contain`.
    ///   - backgroundColor: Background color for letterboxing areas. Default is "transparent".
    ///   - items: Other items to place inside this slide, which will
    ///     be placed on top of the background image.
    public init(
        background: String? = nil,
        imageFit: ImageFit = .contain,
        backgroundColor: String = "transparent",
        @HTMLBuilder items: () -> some HTML
    ) {
        self.background = background
        self.items = HTMLCollection(items)
        self.imageFit = imageFit
        self.containerBackgroundColor = backgroundColor
    }

    /// Adjusts the opacity of the background image for this slide. Use values
    /// lower than 1.0 to progressively dim the background image.
    /// - Parameter opacity: The new opacity for this slide.
    /// - Returns: A new `Slide` instance with the updated background opacity.
    public func backgroundOpacity(_ opacity: Double) -> Slide {
        var copy = self
        copy.backgroundOpacity = opacity
        return copy
    }

    /// Sets how the background image should fit within the slide container.
    /// - Parameter fit: The image fit mode.
    /// - Returns: A new `Slide` instance with the updated image fit.
    public func imageFit(_ fit: ImageFit) -> Slide {
        var copy = self
        copy.imageFit = fit
        return copy
    }

    /// Sets the background color used for letterboxing.
    /// - Parameter color: The CSS color value (e.g., "black", "#000", "rgba(0,0,0,0.5)").
    /// - Returns: A new `Slide` instance with the updated background color.
    public func backgroundColor(_ color: String) -> Slide {
        var copy = self
        copy.containerBackgroundColor = color
        return copy
    }

    /// Used during rendering to assign this carousel slide to a particular parent,
    /// so our open paging behavior works correctly.
    func assigned(at index: Int) -> some HTML {
        Section {
            if let slideBackground = background {
                Image(slideBackground, description: "")
                    .class("d-block", "w-100")
                    .style(
                        .init(.height, value: "100%"),
                        .init(.objectFit, value: imageFit.rawValue),
                        .init(.opacity, value: backgroundOpacity.formatted(.nonLocalizedDecimal))
                    )
            }

            Section {
                Section(items)
                    .class("carousel-caption")
            }
            .class("container")
        }
        .attributes(attributes)
        .class("carousel-item")
        .class(index == 0 ? "active" : nil)
        .style(.backgroundColor, containerBackgroundColor)
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        items.map { $0.markup() }.joined()
    }
}

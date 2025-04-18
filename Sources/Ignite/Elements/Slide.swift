//
// Slide.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// One slide in a `Carousel`.
public struct Slide: HTML {
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

    /// Creates a new `Slide` object using a background image.
    /// - Parameter background: An optional background image to use for
    /// this slide. This should be specified relative to the root of your
    /// site, e.g. /images/dog.jpg.
    public init(background: String) {
        self.background = background
        self.items = HTMLCollection([])
    }

    /// Creates a new `Slide` object using a background image and a page
    /// element builder that returns an array of `HTML` objects to use
    /// inside the slide.
    /// - Parameter background: An optional background image to use for
    /// this slide. This should be specified relative to the root of your
    /// site, e.g. /images/dog.jpg.
    /// - Parameter items: Other items to place inside this slide, which will
    /// be placed on top of the background image.
    public init(background: String? = nil, @HTMLBuilder items: () -> some HTML) {
        self.background = background
        self.items = HTMLCollection(items)
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

    /// Used during rendering to assign this carousel slide to a particular parent,
    /// so our open paging behavior works correctly.
    func assigned(at index: Int) -> some HTML {
        Section {
            if let slideBackground = background {
                Image(slideBackground, description: "")
                    .class("d-block", "w-100")
                    .style(
                        .init(.height, value: "100%"),
                        .init(.objectFit, value: "cover"),
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
        .style(.backgroundColor, "black")
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        items.map { $0.render() }.joined()
    }
}

//
// StyledHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A concrete type used for style resolution that only holds attributes
@MainActor
public struct StyledHTML: Modifiable {
    /// A collection of styles, classes, and attributes.
    var attributes = CoreAttributes()

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `AttributeValue` objects
    /// - Returns: The modified `HTML` element
    public func style(_ values: AttributeValue...) -> Self {
        var copy = self
        copy.attributes.append(styles: values)
        return copy
    }

    /// Adds inline styles to the element using string format.
    /// - Parameter values: Variable number of style strings in "property: value" format
    /// - Returns: The modified `HTML` element
    @discardableResult public func style(_ values: String...) -> Self {
        var copy = self
        let attributeValues: [AttributeValue] = values.compactMap { value in
            let parts = value.split(separator: ":")
            guard parts.count == 2 else { return nil }
            return AttributeValue(
                name: parts[0].trimmingCharacters(in: .whitespaces),
                value: parts[1].trimmingCharacters(in: .whitespaces)
            )
        }
        copy.attributes.styles.formUnion(attributeValues)
        return copy
    }
}

public extension StyledHTML {
    func background(_ color: Color) -> Self {
        self.style(.init(name: .backgroundColor, value: color.description))
    }

    func background(_ gradient: Gradient) -> Self {
        self.style(.init(name: .backgroundImage, value: gradient.description))
    }

    func border(
        _ color: Color,
        width: Double = 1,
        style: BorderStyle = .solid,
        cornerRadii: CornerRadii = CornerRadii(),
        edges: Edge = .all
    ) -> Self {
        BorderModifier(
            color: color,
            width: width,
            style: style,
            cornerRadii: cornerRadii,
            edges: edges)
        .style(content: self)
    }

    func cornerRadius(_ edges: DiagonalEdge = .all, _ length: LengthUnit) -> Self {
        CornerRadiusModifier(edges: edges, length: length).style(content: self)
    }

    func font(_ font: Font) -> Self {
        var copy = self
        copy.style("font-weight: \(font.weight.rawValue)")
        if let name = font.name, name.isEmpty == false {
            copy.style("font-family: \(name)")
        }
        if let size = font.size {
            copy.style("font-size: \(size.stringValue)")
        }
        return copy
    }

    func fontWeight(_ weight: Font.Weight) -> Self {
        self.style("font-weight: \(weight.rawValue)")
    }

    func foregroundStyle(_ color: Color) -> Self {
        self.style("color: \(color.description)")
    }

    func frame(
        width: LengthUnit? = nil,
        minWidth: LengthUnit? = nil,
        maxWidth: LengthUnit? = nil,
        height: LengthUnit? = nil,
        minHeight: LengthUnit? = nil,
        maxHeight: LengthUnit? = nil,
        alignment: Alignment = .center
    ) -> Self {
        FrameModifier(
            width: width,
            minWidth: minWidth,
            maxWidth: maxWidth,
            height: height,
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: alignment)
        .style(content: self)
    }

    func hidden() -> Self {
        self.style(.init(name: .display, value: "none"))
    }

    func lineSpacing(_ height: Double) -> Self {
        self.style("line-height: \(height)")
    }

    func margin(_ edges: Edge, _ length: LengthUnit) -> Self {
        self.edgeAdjust(prefix: "margin", edges, length.stringValue)
    }

    func opacity(_ percentage: Percentage) -> Self {
        self.style("opacity: \(percentage.value)")
    }

    func padding(_ edges: Edge, _ length: LengthUnit) -> Self {
        self.edgeAdjust(prefix: "padding", edges, length.stringValue)
    }

    func innerShadow(_ color: Color = .black.opacity(0.33), radius: Int, x: Int = 0, y: Int = 0) -> Self{
        let shadow = Shadow(color: color, radius: radius, x: x, y: y, inset: true)
        return self.style("box-shadow: \(shadow)")
    }

    func shadow(_ color: Color = .black.opacity(0.33), radius: Int, x: Int = 0, y: Int = 0) -> Self {
        let shadow = Shadow(color: color, radius: radius, x: x, y: y, inset: false)
        return self.style("box-shadow: \(shadow)")
    }

    func textDecoration(_ style: TextDecoration) -> Self {
        self.style("text-decoration: \(style)")
    }
}

@MainActor
public protocol Modifiable {
    func style(_ values: AttributeValue...) -> Self

    @discardableResult func style(_ values: String...) -> Self
}

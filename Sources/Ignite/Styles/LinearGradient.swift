//
// LinearGradient.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A linear gradient that transitions between colors along a line.
public struct LinearGradient: CustomStringConvertible {
    /// The direction of the gradient
    public enum Direction {
        case top
        case topTrailing
        case trailing
        case bottomTrailing
        case bottom
        case bottomLeading
        case leading
        case topLeading

        var cssValue: String {
            switch self {
            case .top: return "to top"
            case .topTrailing: return "to top right"
            case .trailing: return "to right"
            case .bottomTrailing: return "to bottom right"
            case .bottom: return "to bottom"
            case .bottomLeading: return "to bottom left"
            case .leading: return "to left"
            case .topLeading: return "to top left"
            }
        }
    }

    /// The colors to use in the gradient
    private let colors: [Color]

    /// The direction of the gradient
    private let direction: Direction

    /// Creates a linear gradient with the specified colors and direction
    /// - Parameters:
    ///   - colors: Two or more colors to use for the gradient
    ///   - direction: The direction the gradient should follow
    public init(colors: [Color], direction: Direction = .trailing) {
        self.colors = colors
        self.direction = direction
    }

    /// The CSS representation of this gradient
    public var description: String {
        let colorStops = colors.enumerated().map { index, color in
            let percentage = Double(index) / Double(max(1, colors.count - 1)) * 100
            return "\(color) \(percentage)%"
        }.joined(separator: ", ")

        return "linear-gradient(\(direction.cssValue), \(colorStops))"
    }
}

public extension LinearGradient {
    /// Creates a linear gradient background
    /// - Parameters:
    ///   - colors: The colors to use in the gradient
    ///   - direction: The direction of the gradient
    /// - Returns: A linear gradient background
    static func linearGradient(colors: Color..., direction: LinearGradient.Direction = .trailing) -> LinearGradient {
        LinearGradient(colors: colors, direction: direction)
    }
}

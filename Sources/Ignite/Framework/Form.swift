//
// Form.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form container for collecting user input
public struct Form: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// How many columns this should be divided into
    private var columnCount: Int = 12

    /// The amount of vertical spacing between form elements.
    private var verticalSpacing: SpacingAmount

    /// The amount of horizontal spacing between form elements.
    private var horizontalSpacing: SpacingAmount

    /// The form elements to be rendered.
    private var items: [any InlineHTML]

    /// The action to perform when the form is submitted.
    private var action: (String) -> any Action

    /// Adjusts the number of columns that can be fitted into this section.
    /// - Parameter columns: The number of columns to use
    /// - Returns: A new `Section` instance with the updated column count.
    public func columns(_ columns: Int) -> Self {
        var copy = self
        copy.columnCount = columns
        return copy
    }

    /// Creates a new form with the specified spacing and content.
    /// - Parameters:
    ///   - horizontalSpacing: The amount of horizontal space between elements. Defaults to `.medium`.
    ///   - verticalSpacing: The amount of vertical space between elements. Defaults to `.medium`.
    ///   - content: A closure that returns the form's elements.
    ///   - onSubmit: A closure that takes the form's ID as a parameter and returns the action to perform when the form is submitted.
    public init(
        horizontalSpacing: SpacingAmount = .medium,
        verticalSpacing: SpacingAmount = .medium,
        @InlineHTMLBuilder content: () -> some InlineHTML,
        onSubmit: @escaping (String) -> any Action
    ) {
        self.items = flatUnwrap(content())
        self.action = onSubmit
        self.verticalSpacing = verticalSpacing
        self.horizontalSpacing = horizontalSpacing
        attributes.id = UUID().uuidString.truncatedHash
    }

    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = "form"
        let action = action(attributes.id)

        if let action = action as? SubscribeAction {
            attributes.customAttributes.insert(.init(name: "method", value: "post"))
            attributes.customAttributes.insert(.init(name: "action", value: action.endpoint))
        }

        // Wrap content in a row with columns
        let wrappedContent = Group {
            Group {
                ForEach(items) { item in
                    Group(item)
                        .class(getColumnClass(for: item, totalColumns: columnCount))
                }
            }
            .class("row", "g-\(horizontalSpacing.rawValue)", "gy-\(verticalSpacing.rawValue)")
        }
            .render(context: context)

        var output = wrappedContent
        output += Script(code: action.compile()).render(context: context)

        return attributes.description(wrapping: output)
    }

    /// Calculates the appropriate Bootstrap column class for an HTML element.
    /// - Parameters:
    ///   - item: The HTML element to calculate the column class for.
    ///   - totalColumns: The total number of columns in the form's grid.
    /// - Returns: A string containing the appropriate Bootstrap column class.
    private func getColumnClass(for item: any HTML, totalColumns: Int) -> String {
        if let item = item as? (any BlockHTML),
           case .count(let width) = item.columnWidth {
            // Convert the width from form columns to Bootstrap columns
            let bootstrapColumns = 12 * width / totalColumns
            return "col-md-\(bootstrapColumns)"
        } else {
            // Default to one column width if not specified
            return "col-md-\(12 / totalColumns)"
        }
    }
}

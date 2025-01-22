//
// AriaType.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents ARIA attributes that can be applied to HTML elements.
/// These attributes help make web content more accessible to people with disabilities.
public enum AriaType: String {
    /// Identifies the currently active element when focus is on a composite widget
    case activeDescendant = "aria-activedescendant"

    /// Indicates whether assistive technologies will present all or parts of the changed region
    case atomic = "aria-atomic"

    /// Indicates whether inputting text could trigger display of predictions
    case autocomplete = "aria-autocomplete"

    /// Defines a string value that labels the current element in Braille
    case brailleLabel = "aria-braillelabel"

    /// Defines a human-readable description for the role of an element in Braille
    case brailleRoleDescription = "aria-brailleroledescription"

    /// Indicates an element is being modified
    case busy = "aria-busy"

    /// Indicates the current checked state of checkboxes, radio buttons, and other widgets
    case checked = "aria-checked"

    /// Defines the total number of columns in a table, grid, or treegrid
    case columnCount = "aria-colcount"

    /// Defines an element's column index or position
    case columnIndex = "aria-colindex"

    /// Defines a human-readable text alternative of the numeric colindex
    case columnIndexText = "aria-colindextext"

    /// Defines the number of columns spanned by a cell or gridcell
    case columnSpan = "aria-colspan"

    /// Identifies the element(s) whose contents or presence are controlled by the current element
    case controls = "aria-controls"

    /// Indicates the current item within a container or set of related elements
    case current = "aria-current"

    /// Identifies the element(s) that describes the current element
    case describedBy = "aria-describedby"

    /// Defines a string value that describes or annotates the current element
    case description = "aria-description"

    /// Identifies the element(s) that provide additional information
    case details = "aria-details"

    /// Indicates that the element is perceivable but disabled
    case disabled = "aria-disabled"

    /// Indicates what functions can be performed when a dragged object is released
    case dropEffect = "aria-dropeffect"

    /// Identifies the element that provides an error message
    case errorMessage = "aria-errormessage"

    /// Indicates if a control is expanded or collapsed
    case expanded = "aria-expanded"

    /// Identifies the next element(s) in an alternate reading order
    case flowTo = "aria-flowto"

    /// Indicates an element's grabbed state in drag-and-drop
    case grabbed = "aria-grabbed"

    /// Indicates the availability and type of interactive popup element
    case hasPopup = "aria-haspopup"

    /// Indicates whether the element is exposed to an accessibility API
    case hidden = "aria-hidden"

    /// Indicates the entered value does not conform to the expected format
    case invalid = "aria-invalid"

    /// Indicates keyboard shortcuts
    case keyboardShortcuts = "aria-keyshortcuts"

    /// Defines a string value that labels the current element
    case label = "aria-label"

    /// Identifies the element(s) that labels the current element
    case labelledBy = "aria-labelledby"

    /// Defines the hierarchical level of an element
    case level = "aria-level"

    /// Indicates that an element will be updated
    case live = "aria-live"

    /// Indicates whether an element is modal when displayed
    case modal = "aria-modal"

    /// Indicates whether a textbox accepts multiple lines
    case multiline = "aria-multiline"

    /// Indicates that the user may select multiple items
    case multiselectable = "aria-multiselectable"

    /// Indicates whether the element's orientation is horizontal, vertical, or unknown
    case orientation = "aria-orientation"

    /// Identifies element(s) to define a visual, functional, or contextual relationship
    case owns = "aria-owns"

    /// Defines a short hint for data entry
    case placeholder = "aria-placeholder"

    /// Defines an element's number or position in the current set
    case positionInSet = "aria-posinset"

    /// Indicates the current pressed state of toggle buttons
    case pressed = "aria-pressed"

    /// Indicates that the element is not editable
    case readOnly = "aria-readonly"

    /// Indicates what notifications the user agent will trigger
    case relevant = "aria-relevant"

    /// Indicates that user input is required
    case required = "aria-required"

    /// Defines a human-readable description for the role of an element
    case roleDescription = "aria-roledescription"

    /// Defines the total number of rows in a table, grid, or treegrid
    case rowCount = "aria-rowcount"

    /// Defines an element's row index or position
    case rowIndex = "aria-rowindex"

    /// Defines a human-readable text alternative of rowindex
    case rowIndexText = "aria-rowindextext"

    /// Defines the number of rows spanned by a cell or gridcell
    case rowSpan = "aria-rowspan"

    /// Indicates the current selected state of various widgets
    case selected = "aria-selected"

    /// Defines the number of items in the current set
    case setSize = "aria-setsize"

    /// Indicates if items are sorted in ascending or descending order
    case sort = "aria-sort"

    /// Defines the maximum allowed value for a range widget
    case valueMax = "aria-valuemax"

    /// Defines the minimum allowed value for a range widget
    case valueMin = "aria-valuemin"

    /// Defines the current value for a range widget
    case valueNow = "aria-valuenow"

    /// Defines the human readable text alternative of valuenow
    case valueText = "aria-valuetext"
}

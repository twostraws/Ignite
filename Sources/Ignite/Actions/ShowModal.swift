//
// ShowModal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Shows a modal dialog with the content of the page element identified by ID
public struct ShowModal: Action, Sendable {

    /// The options used to configure the modal presentation
    public enum Option: Sendable {
        /// Shows the modal with a backdrop optionally dismissible by clicking on the backdrop.
        /// - Parameter dismissible: Whether the modal can be dismissed by clicking on the backdrop. Default is `true`.
        case backdrop(dismissible: Bool)

        /// Shows the modal without backdrop. It is not dismissed when clicking outside the modal.
        case noBackdrop

        /// Focuses on the modal when opened.
        /// - Parameter bool: Whether the modal should be focused when opened. Default is `true`.
        case focus(Bool)

        /// Option to close the modal when escape key is pressed.
        /// - Parameter bool: Whether the modal should close when escape key is pressed. Default is `true`.
        case keyboard(Bool)

        var htmlOption: String {
            switch self {
            case .backdrop(let dismissible):
                "backdrop: \(dismissible ? "true" : "'static'")"
            case .noBackdrop:
                "backdrop: false"
            case .focus(let bool):
                "focus: \(bool.description)"
            case .keyboard(let bool):
                "keyboard: \(bool.description)"
            }
        }
    }

    /// The unique identifier of the element to display in the modal dialog.
    let id: String

    /// The options used to configure the modal
    let options: [Option]

    /// Creates a new ShowModal action from a specific page element ID.
    /// - Parameters:
    ///   - id: The unique identifier of the element we're trying to show as a modal.
    ///   - options: An array of modal configuration options.
    public init(id: String, options: [Option] = []) {
        self.id = id
        self.options = options
    }

    /// Renders this action using publishing context passed in.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        """
        const options = {
            \(options.map(\.htmlOption).joined(separator: ",\n\t"))
        };
        const modal = new bootstrap.Modal(document.getElementById('\(id)'), options);
        modal.show();
        """
    }
}

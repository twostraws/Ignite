//
// DismissModal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Dismiss a modal dialog with the content of the page element identified by ID
public struct DismissModal: Action {
    /// The unique identifier of the element of the modal we're trying to dismiss.
    var id: String

    /// Creates a new DismissModal action from a specific page element ID.
    /// - Parameter id: The unique identifier of the element of the modal we're trying to dismiss.
    public init(id: String) {
        self.id = id
    }

    /// Renders this action using publishing context passed in.
    /// - Returns: The JavaScript for this action.
    public func compile() -> String {
        """
        const modal = document.getElementById('\(id)');
        const modalInstance = bootstrap.Modal.getInstance(modal);
        if (modalInstance) { modalInstance.hide(); }
        """
    }
}

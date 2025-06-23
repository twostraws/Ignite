//
// ModalPosition.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The vertical position of the modal dialog on the screen.
public enum ModalPosition: CaseIterable, Sendable {
    /// Positions the modal at the top of the screen.
    case top

    /// Positions the modal in the center of the screen.
    case center

    /// The HTML class name for the modal position.
    var htmlName: String? {
        switch self {
        case .top: nil
        case .center: "modal-dialog-centered"
        }
    }
}

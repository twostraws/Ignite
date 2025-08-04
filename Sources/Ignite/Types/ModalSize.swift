//
// ModalSize.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The size of the modal dialog.
///
/// The height is determined by the content, while the width is fixed based on the selected size.
public enum ModalSize: CaseIterable, Sendable {
    /// A modal dialog with a small max-width of 300px.
    case small

    /// A modal dialog with a medium max-width of 500px.
    case medium

    /// A modal dialog with a large max-width of 800px.
    case large

    /// A modal dialog with an extra large max-width of 1140px.
    case xLarge

    /// A fullscreen modal dialog covering the entire viewport.
    case fullscreen

    /// The HTML class name for the modal size.
    var htmlClass: String? {
        switch self {
        case .small: "modal-sm"
        case .medium: nil
        case .large: "modal-lg"
        case .xLarge: "modal-xl"
        case .fullscreen: "modal-fullscreen"
        }
    }
}

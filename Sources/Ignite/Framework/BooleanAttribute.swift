//
// BooleanAttribute.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An enumeration of HTML boolean attributes.
///
/// Boolean attributes are attributes that can be present or absent on an HTML element,
/// where their presence indicates true and their absence indicates false.
enum BooleanAttribute: String {
    /// Indicates whether an `<iframe>` can be displayed in fullscreen mode.
    case allowFullscreen = "allowfullscreen"

    /// Specifies that a script should be executed asynchronously.
    case async = "async"

    /// Indicates that an element should automatically get focus when the page loads.
    case autofocus = "autofocus"

    /// Specifies that media will start playing automatically.
    case autoplay = "autoplay"

    /// Indicates whether a form control is checked.
    case checked = "checked"

    /// Indicates whether the user can control media playback.
    case controls = "controls"

    /// Indicates that a track is to be enabled if the user's preferences don't indicate something different.
    case `default` = "default"

    /// Specifies that a script should be executed after the page has finished parsing.
    case `defer` = "defer"

    /// Indicates whether a form control is disabled.
    case disabled = "disabled"

    /// Indicates that form validation should be skipped.
    case formNoValidate = "formnovalidate"

    /// Indicates whether an element is inert.
    case inert = "inert"

    /// Indicates that an image is part of a server-side image map.
    case isMap = "ismap"

    /// Indicates that the element contains microdata.
    case itemScope = "itemscope"

    /// Indicates whether media should play repeatedly.
    case loop = "loop"

    /// Indicates that multiple values can be selected.
    case multiple = "multiple"

    /// Indicates whether media should be initially muted.
    case muted = "muted"

    /// Indicates that the script should not be executed in browsers supporting ES2015 modules.
    case noModule = "nomodule"

    /// Indicates that form validation should be skipped.
    case noValidate = "novalidate"

    /// Indicates whether an element's content is expanded.
    case open = "open"

    /// Indicates that video should play inline on iOS.
    case playsInline = "playsinline"

    /// Indicates that a form control's value cannot be modified.
    case readOnly = "readonly"

    /// Indicates that a form control must have a value.
    case required = "required"

    /// Indicates that a list should be displayed in reverse order.
    case reversed = "reversed"

    /// Indicates whether an option is selected.
    case selected = "selected"

    /// Indicates whether a shadow root is clonable.
    case shadowRootClonable = "shadowrootclonable"

    /// Indicates whether a shadow root delegates focus.
    case shadowRootDelegatesFocus = "shadowrootdelegatesfocus"

    /// Indicates whether a shadow root is serializable.
    case shadowRootSerializable = "shadowrootserializable"
}

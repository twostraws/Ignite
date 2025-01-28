//
// EventType.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum EventType: String, Sendable {
    // Window Events
    case afterPrint = "onafterprint"
    case beforePrint = "onbeforeprint"
    case beforeUnload = "onbeforeunload"
    case error = "onerror"
    case hashChange = "onhashchange"
    case load = "onload"
    case message = "onmessage"
    case offline = "onoffline"
    case online = "ononline"
    case pageHide = "onpagehide"
    case pageShow = "onpageshow"
    case popState = "onpopstate"
    case resize = "onresize"
    case storage = "onstorage"
    case unload = "onunload"

    // Form Events
    case blur = "onblur"
    case change = "onchange"
    case contextMenu = "oncontextmenu"
    case focus = "onfocus"
    case focusIn = "onfocusin"
    case focusOut = "onfocusout"
    case input = "oninput"
    case invalid = "oninvalid"
    case reset = "onreset"
    case search = "onsearch"
    case select = "onselect"
    case submit = "onsubmit"
    case formData = "onformdata"

    // Keyboard Events
    case keyDown = "onkeydown"
    case keyPress = "onkeypress"
    case keyUp = "onkeyup"

    // Mouse Events
    case click = "onclick"
    case doubleClick = "ondblclick"
    case mouseDown = "onmousedown"
    case mouseMove = "onmousemove"
    case mouseOut = "onmouseout"
    case mouseOver = "onmouseover"
    case mouseUp = "onmouseup"
    case wheel = "onwheel"

    // Drag Events
    case drag = "ondrag"
    case dragEnd = "ondragend"
    case dragEnter = "ondragenter"
    case dragLeave = "ondragleave"
    case dragOver = "ondragover"
    case dragStart = "ondragstart"
    case drop = "ondrop"
    case scroll = "onscroll"

    // Clipboard Events
    case copy = "oncopy"
    case cut = "oncut"
    case paste = "onpaste"

    // Media Events
    case abort = "onabort"
    case canPlay = "oncanplay"
    case canPlayThrough = "oncanplaythrough"
    case cueChange = "oncuechange"
    case durationChange = "ondurationchange"
    case emptied = "onemptied"
    case ended = "onended"
    case loadedData = "onloadeddata"
    case loadedMetadata = "onloadedmetadata"
    case loadStart = "onloadstart"
    case pause = "onpause"
    case play = "onplay"
    case playing = "onplaying"
    case progress = "onprogress"
    case rateChange = "onratechange"
    case seeked = "onseeked"
    case seeking = "onseeking"
    case stalled = "onstalled"
    case suspend = "onsuspend"
    case timeUpdate = "ontimeupdate"
    case volumeChange = "onvolumechange"
    case waiting = "onwaiting"

    // Touch Events
    case touchStart = "ontouchstart"
    case touchMove = "ontouchmove"
    case touchEnd = "ontouchend"
    case touchCancel = "ontouchcancel"

    // Pointer Events
    case pointerDown = "onpointerdown"
    case pointerMove = "onpointermove"
    case pointerUp = "onpointerup"
    case pointerCancel = "onpointercancel"
    case pointerEnter = "onpointerenter"
    case pointerLeave = "onpointerleave"
    case pointerOver = "onpointerover"
    case pointerOut = "onpointerout"

    // Animation Events
    case animationStart = "onanimationstart"
    case animationEnd = "onanimationend"
    case animationIteration = "onanimationiteration"

    // Transition Events
    case transitionEnd = "ontransitionend"
    case transitionStart = "ontransitionstart"
    case transitionCancel = "ontransitioncancel"
    case transitionRun = "ontransitionrun"

    // Visibility Events
    case visibilityChange = "onvisibilitychange"

    // Misc Events
    case toggle = "ontoggle"

    // Helper method to get the attribute name without 'on' prefix
    var withoutPrefix: String {
        let attributeName = self.rawValue
        return String(attributeName.dropFirst(2))
    }
}

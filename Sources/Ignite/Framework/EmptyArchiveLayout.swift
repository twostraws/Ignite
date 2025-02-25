//
// EmptyTagLayout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A default archive layout that does nothing; used to disable archive pages entirely.
public struct EmptyArchiveLayout: ArchiveLayout {
    public var body: some HTML {
        EmptyHTML()
    }
}

//
// EmptyStaticPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A default static page that does nothing; used to disable tag pages entirely.
public struct EmptyStaticPage: StaticPage {
    public var title: String = ""

    public var body: some HTML { 
        EmptyHTML()
     }
}
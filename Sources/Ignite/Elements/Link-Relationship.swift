//
// Link-Relationship.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Link {
    /// Describes what kind of link this is.
    public enum Relationship: String {
        /// Alternate versions of this current code.
        case alternate = "alternate"

        /// An augmented-reality resource for this page.
        case ar = "ar" // swiftlint:disable:this identifier_name

        /// A link to the creator of this page.
        case author = "author"

        /// A permanent link for this page.
        case bookmark = "bookmark"

        /// Marks that this is the preferred URL for this resource.
        case canonical = "canonical"

        /// Instructs the browser to look up DNS details for this
        /// resource immediately.
        case dnsPrefetch = "dns-prefetch"

        /// Marks that this resource belongs to a different site.
        case external = "external"

        /// This resource points to further help about this page.
        case help = "help"

        /// An icon representing this document.
        case icon = "icon"

        /// This link points to a specific license that applies to the current page.
        case license = "license"

        /// This link points to the web app manifest for the current page.
        case manifest = "manifest"

        /// Used for links about a person when they point to other pages about
        /// the same person.
        case me = "me" // swiftlint:disable:this identifier_name

        /// Instructs the browser to preload a script immediately.
        case modulePreload = "modulepreload"

        /// Marks this document as being part of a series, where the next
        /// document is contained in this link.
        case next = "next"

        /// Indicates to search engines that this link should not be followed,
        /// This is helpful when linking to external sites – if they do something
        /// that Google et al frown upon the future, that won't somehow affect
        /// your site ranking.
        case noFollow = "nofollow"

        /// Adds an extra layer of security when opening links to resources
        /// not owned by you, by disallowing them to access JavaScript's
        /// `window.opener` property.
        case noOpener = "noopener"

        /// Disables the HTTP referrer header from being included, and
        /// also includes `.noOpener`.
        case noReferrer = "noreferrer"

        /// Pages opened with this attribute are allowed have control over
        /// the original page, such as changing its URL. Please use with care.
        case opener = "opener"

        /// Provides the address of the server that handles pingback events for
        /// the current page.
        case pingback = "pingback"

        /// Instructs the browser to immediately make a connection to the server
        /// providing this resource. Useful when you know data from there will
        /// be accessed very soon.
        case preconnect = "preconnect"

        /// Instructs the browser to immediately fetch the linked data. Useful when
        /// you know the data will be needed immediately.
        case prefetch = "prefetch"

        /// Instructs the browser to immediately fetch and fully process the
        /// linked data. Useful when you know the data will be needed immediately.
        case prerender = "prerender"

        /// Marks this document as being part of a series, where the previous
        /// document is contained in this link.
        case prev = "previous"

        /// This link points to the privacy policy for the current page.
        case privacyPolicy = "privacy-policy"

        /// This link points to the search page for your site.
        case search = "search"

        /// Brings a CSS file into your page.
        case stylesheet = "stylesheet"

        /// Marks this link as pointing to a page consisting of content belonging
        /// to a particular tag string.
        case tag = "tag"

        /// This link points to the legal terms of service for the current page.
        case termsOfService = "terms-of-service"
    }
}

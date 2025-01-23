//
// HTMLBody.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

// swiftlint:disable force_try
/// Tests for the `title` element.
@Suite("Body Tests")
@MainActor struct SubsiteBodyTests {
   static let sites: [any Site] = [TestSite(), TestSubsite()]

   @Test("Simple Body Test", arguments: await [any Site](Self.sites))
   func simpleBody(for site: any Site) async throws {
       try! PublishingContext.initialize(for: site, from: #filePath)

       let element = HTMLBody(
           for: Page(
               title: "TITLE", description: "DESCRIPTION",
               url: site.url,
               body: Text("TEXT")))
       let output = element.render()

       let jsPath = site.url.pathComponents.count <= 1 ? "/js" : "\(site.url.path)/js"
       #expect(
           output == """
           <body class="container"><p>TEXT</p>\
           <script src="\(jsPath)/bootstrap.bundle.min.js"></script>\
           <script src="\(jsPath)/ignite-core.js"></script>\
           </body>
           """
       )
   }
}
// swiftlint:enable force_try

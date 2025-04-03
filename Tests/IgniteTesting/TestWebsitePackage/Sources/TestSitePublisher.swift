//
// TestSitePublisher.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// A test publisher for ``TestSite``.
///
/// It helps to run `TestSite/publish` with a correct path of the file that triggered the build.
@MainActor
struct TestSitePublisher {
    var site: any Site = TestSite()

    mutating func publish() async throws {
        try await site.publish()
    }
}

//
// PublishingContextTrait.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing
@testable import Ignite

enum TestPublishingSite: Sendable {
    case standard
    case relativePaths
    case subsite
    case relativePathsSubsite

    static let standardAndSubsite: [Self] = [.standard, .subsite]

    var site: any Site {
        switch self {
        case .standard:
            TestSite()
        case .relativePaths:
            TestRelativePathsSite()
        case .subsite:
            TestSubsite()
        case .relativePathsSubsite:
            TestRelativePathsSubsite()
        }
    }
}

struct PublishingContextTrait: TestTrait, TestScoping {
    let site: TestPublishingSite
    let file: StaticString

    var isRecursive: Bool { false }

    func provideScope(
        for test: Testing.Test,
        testCase: Testing.Test.Case?,
        performing function: @Sendable () async throws -> Void
    ) async throws {
        let context = try PublishingContext.initialize(for: site.site, from: file)

        try await PublishingContext.withCurrent(context) {
            try await function()
        }
    }
}

extension TestTrait where Self == PublishingContextTrait {
    static func publishingContext(
        _ site: TestPublishingSite = .standard,
        from file: StaticString = #filePath
    ) -> Self {
        PublishingContextTrait(site: site, file: file)
    }
}

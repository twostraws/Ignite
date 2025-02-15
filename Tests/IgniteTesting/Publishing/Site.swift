//
// Site.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Site` type.
///
/// > Warning: Calling `PublishingContext.initialize` as a part of the suite set-up
/// can lead to false positive results because these tests are calling `TestSite/publish`
/// that includes the `PublishingContext.initialize` call.
/// **Workaround:** Run this suite in isolation.
@Suite("Site Tests", .serialized)
@MainActor
struct SiteTests {
    private let package = TestPackage()

    init() {
        try? package.clearBuildFolderAndTestContent()
    }

    @Test("Site published when Markdown content contains invalid lastModified date")
    func publishingWithInvalidLastModifiedDate() async throws {
        let markdownFileURL = package.contentDirectoryURL.appending(path: "story-with-invalid-lastModified.md")
        let markdownContent = """
        ---
        layout: TestStory
        lastModified: 03-30-2020 16:37:21
        ---

        # Story with invalid lastModified
        """

        try markdownContent.write(to: markdownFileURL, atomically: false, encoding: .utf8)

        try await TestSitePublisher().publish()

        #expect(package.checkIndexFileExists() == true)

        try package.clearBuildFolderAndTestContent()
    }

    @Test("Site published given Markdown content with valid metadata")
    func publishingWithMarkdownContent() async throws {
        let markdownFileURL = package.contentDirectoryURL.appending(path: "story-with-valid-metadata.md")
        let markdownContent = """
        ---
        layout: TestStory
        lastModified: 2020-03-30 16:37
        ---

        # Story with valid metadata
        """

        try markdownContent.write(to: markdownFileURL, atomically: false, encoding: .utf8)

        try await TestSitePublisher().publish()

        #expect(package.checkIndexFileExists() == true)

        try package.clearBuildFolderAndTestContent()
    }
}

private struct TestPackage {
    let packageBaseURL: URL
    let buildDirectoryURL: URL
    let contentDirectoryURL: URL

    init() {
        packageBaseURL = URL(filePath: #filePath, directoryHint: .isDirectory)
            .deletingLastPathComponent() // "Site.swift"
            .deletingLastPathComponent() // "Publishing/"
            .appending(path: "TestWebsitePackage")
        buildDirectoryURL = packageBaseURL.appending(path: "Build")
        contentDirectoryURL = packageBaseURL.appending(path: "Content")
    }

    func checkIndexFileExists() -> Bool {
        (try? buildDirectoryURL.appending(path: "index.html").checkPromisedItemIsReachable()) ?? false
    }

    func clearBuildFolderAndTestContent() throws {
        try FileManager.default.removeItem(at: buildDirectoryURL)
        let enumerator = FileManager.default.enumerator(at: contentDirectoryURL, includingPropertiesForKeys: nil)
        while let fileURL = enumerator?.nextObject() as? URL {
            guard fileURL.isFileURL, fileURL.pathExtension == "md" else { continue }
            try FileManager.default.removeItem(at: fileURL)
        }
    }
}

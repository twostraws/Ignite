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

        var site = TestSitePublisher()
        try await site.publish()

        #expect(package.checkIndexFileExists())

        try package.clearBuildFolderAndTestContent()
    }

    @Test("Retrieving typed content")
    func retrievingTypedContent() async throws {
        var package = TestPackage()
        package.contentDirectoryURL = package.contentDirectoryURL.appending(path: "Story", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: package.contentDirectoryURL, withIntermediateDirectories: true)
        let markdownFileURL = package.contentDirectoryURL.appending(path: "story-with-invalid-lastModified.md")

        let markdownContent = """
        ---
        layout: TestStory
        lastModified: 2020-03-30 16:37
        ---

        # Content typed Story
        """

        try markdownContent.write(to: markdownFileURL, atomically: false, encoding: .utf8)

        var site = TestSitePublisher()
        try await site.publish()

        let context = PublishingContext.shared
        let articleLoader = ArticleLoader(content: context.allContent)

        #expect(articleLoader.typed("Story").isEmpty == false)

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

        var site = TestSitePublisher()
        try await site.publish()

        #expect(package.checkIndexFileExists())

        try package.clearBuildFolderAndTestContent()
    }

    @Test("Sites published without an ErrorPage")
    func publishingWithoutErrorPage() async throws {
        var site = TestSitePublisher()

        try await site.publish()

        #expect(package.checkFileExists(at: "404.html") == false)

        try package.clearBuildFolderAndTestContent()
    }

    @Test("Site published with a custom ErrorPage")
    func publishingWithCustomErrorPage() async throws {
        var site = TestSitePublisher(site: TestSiteWithErrorPage())

        try await site.publish()

        #expect(package.checkFileExists(at: "404.html"))

        try package.clearBuildFolderAndTestContent()
    }

    @Test("Site published with a custom ErrorPage and custom content")
    func publishingWithCustomErrorPageAndContent() async throws {
        let expectedError = PageNotFoundError()

        let errorPage = TestErrorPage(title: "A different title", description: "A different description") { error in
            #expect(error.statusCode == expectedError.statusCode)
        }
        let site = TestSiteWithErrorPage(errorPage: errorPage)
        var publisher = TestSitePublisher(site: site)

        try await publisher.publish()

        #expect(package.checkFileExists(at: "404.html"))
        #expect(try package.contentsOfFile(at: "404.html").contains("A different title"))
        #expect(try package.contentsOfFile(at: "404.html").contains("A different description"))

        try package.clearBuildFolderAndTestContent()
    }

}

private struct TestPackage {
    var packageBaseURL: URL
    var buildDirectoryURL: URL
    var contentDirectoryURL: URL

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

    func checkFileExists(at path: String) -> Bool {
        let fileURL = buildDirectoryURL.appending(path: path)
        return (try? fileURL.checkPromisedItemIsReachable()) ?? false
    }

    func contentsOfFile(at path: String) throws -> String {
        let fileURL = buildDirectoryURL.appending(path: path)
        return try String(contentsOf: fileURL, encoding: .utf8)
    }

    func clearBuildFolderAndTestContent() throws {
        try FileManager.default.removeItem(at: buildDirectoryURL)
        let enumerator = FileManager.default.enumerator(at: contentDirectoryURL, includingPropertiesForKeys: nil)
        while let fileURL = enumerator?.nextObject() as? URL {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
}

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
@Suite("Site Tests", .serialized)
struct SiteTests {
    private let package = TestPackage()

    init() {
        try? package.clearBuildFolderAndTestContent()
    }

    @Test("Site published when Markdown content contains invalid lastModified date", .publishingContext())
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

    @Test("Retrieving typed content", .publishingContext())
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

        let site = TestSitePublisher().site
        let context = try PublishingContext.withInitialized(
            for: site,
            sourceDirectory: package.packageBaseURL,
            buildDirectory: package.buildDirectoryURL
        ) { context in
            try context.parseContent()
            return context
        }
        let articleLoader = ArticleLoader(content: context.allContent)

        #expect(articleLoader.typed("Story").isEmpty == false)

        try package.clearBuildFolderAndTestContent()
    }

    @Test("Site published given Markdown content with valid metadata", .publishingContext())
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

    @Test("Sites published without an ErrorPage", .publishingContext())
    func publishingWithoutErrorPage() async throws {
        var site = TestSitePublisher()

        try await site.publish()

        #expect(package.checkFileExists(at: "404.html") == false)

        try package.clearBuildFolderAndTestContent()
    }

    @Test("Site published with a custom ErrorPage", .publishingContext())
    func publishingWithCustomErrorPage() async throws {
        var site = TestSitePublisher(site: TestSiteWithErrorPage())

        try await site.publish()

        #expect(package.checkFileExists(at: "404.html"))

        try package.clearBuildFolderAndTestContent()
    }

    @Test("Site published with a custom ErrorPage and custom content", .publishingContext())
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
        try? FileManager.default.createDirectory(
            at: contentDirectoryURL,
            withIntermediateDirectories: false)
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
        try? FileManager.default.removeItem(at: buildDirectoryURL)
        let enumerator = FileManager.default.enumerator(at: contentDirectoryURL, includingPropertiesForKeys: nil)
        while let fileURL = enumerator?.nextObject() as? URL {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
}

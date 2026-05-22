//
// RelativePathsTests.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `useRelativePaths` site property.
@Suite("Relative Paths Tests")
struct RelativePathsTests {

    // MARK: - Default Behavior (useRelativePaths = false)

    @Test("Default behavior produces absolute paths with leading slash", .publishingContext())
    func defaultBehaviorProducesAbsolutePaths() throws {
        try withPublishingContext(for: TestSite()) { context in
            // Test path(for:) with a local URL
            let localURL = URL(string: "/js/test.js")!
            let result = context.path(for: localURL)
            #expect(result == "/js/test.js")

            // Test assetPath with a local path
            let assetResult = context.assetPath("/css/styles.css")
            #expect(assetResult == "/css/styles.css")
        }
    }

    @Test("Default behavior for MetaLink produces absolute paths", .publishingContext())
    func defaultMetaLinkProducesAbsolutePaths() throws {
        let output = try withPublishingContext(for: TestSite()) { _ in
            let metaLink = MetaLink(href: "/css/bootstrap.min.css", rel: .stylesheet)
            return metaLink.markupString()
        }

        #expect(output.contains("href=\"/css/bootstrap.min.css\""))
    }

    @Test("Default behavior for Script produces absolute paths", .publishingContext())
    func defaultScriptProducesAbsolutePaths() throws {
        let output = try withPublishingContext(for: TestSite()) { _ in
            let script = Script(file: "/js/test.js")
            return script.markupString()
        }

        #expect(output.contains("src=\"/js/test.js\""))
    }

    @Test("Default behavior for Link produces absolute paths", .publishingContext())
    func defaultLinkProducesAbsolutePaths() throws {
        let output = try withPublishingContext(for: TestSite()) { _ in
            let link = Link("Test", target: "/about")
            return link.markupString()
        }

        #expect(output.contains("href=\"/about/\""))
    }

    // MARK: - Relative Paths Behavior (useRelativePaths = true)

    @Test("useRelativePaths strips leading slash from path(for:)", .publishingContext())
    func relativePathsStripsLeadingSlash() throws {
        let result = try withPublishingContext(for: TestRelativePathsSite()) { context in
            let localURL = URL(string: "/js/test.js")!
            return context.path(for: localURL)
        }

        #expect(result == "js/test.js")
    }

    @Test("useRelativePaths strips leading slash from assetPath", .publishingContext())
    func relativeAssetPathStripsLeadingSlash() throws {
        let result = try withPublishingContext(for: TestRelativePathsSite()) { context in
            context.assetPath("/css/styles.css")
        }

        #expect(result == "css/styles.css")
    }

    @Test("useRelativePaths for MetaLink produces relative paths", .publishingContext())
    func relativeMetaLinkProducesRelativePaths() throws {
        let output = try withPublishingContext(for: TestRelativePathsSite()) { _ in
            let metaLink = MetaLink(href: "/css/bootstrap.min.css", rel: .stylesheet)
            return metaLink.markupString()
        }

        #expect(output.contains("href=\"css/bootstrap.min.css\""))
        #expect(!output.contains("href=\"/css/bootstrap.min.css\""))
    }

    @Test("useRelativePaths for Script produces relative paths", .publishingContext())
    func relativeScriptProducesRelativePaths() throws {
        let output = try withPublishingContext(for: TestRelativePathsSite()) { _ in
            let script = Script(file: "/js/bootstrap.bundle.min.js")
            return script.markupString()
        }

        #expect(output.contains("src=\"js/bootstrap.bundle.min.js\""))
        #expect(!output.contains("src=\"/js/bootstrap.bundle.min.js\""))
    }

    @Test("useRelativePaths for Link produces relative paths", .publishingContext())
    func relativeLinkProducesRelativePaths() throws {
        let output = try withPublishingContext(for: TestRelativePathsSite()) { _ in
            let link = Link("About", target: "/about")
            return link.markupString()
        }

        #expect(output.contains("href=\"about/\""))
        #expect(!output.contains("href=\"/about/\""))
    }

    // MARK: - Subsite Support

    @Test("Subsite with default paths includes subsite prefix", .publishingContext())
    func subsiteDefaultPathsIncludePrefix() throws {
        let result = try withPublishingContext(for: TestSubsite()) { context in
            // assetPath should include subsite prefix
            context.assetPath("/css/styles.css")
        }

        #expect(result == "/subsite/css/styles.css")
    }

    @Test("Subsite with relative paths includes subsite prefix without leading slash", .publishingContext())
    func subsiteRelativePathsIncludePrefixWithoutSlash() throws {
        let result = try withPublishingContext(for: TestRelativePathsSubsite()) { context in
            // assetPath should include subsite prefix but no leading slash
            context.assetPath("/css/styles.css")
        }

        #expect(result == "subsite/css/styles.css")
    }

    @Test("Subsite MetaLink with relative paths produces correct output", .publishingContext())
    func subsiteRelativeMetaLinkOutput() throws {
        let output = try withPublishingContext(for: TestRelativePathsSubsite()) { _ in
            let metaLink = MetaLink(href: "/css/bootstrap.min.css", rel: .stylesheet)
            return metaLink.markupString()
        }

        #expect(output.contains("href=\"subsite/css/bootstrap.min.css\""))
    }

    // MARK: - External URLs Should Not Be Modified

    @Test("External URLs are never modified by path(for:)", .publishingContext())
    func externalURLsNotModified() throws {
        let result = try withPublishingContext(for: TestRelativePathsSite()) { context in
            let externalURL = URL(string: "https://cdn.example.com/lib.js")!
            return context.path(for: externalURL)
        }

        #expect(result == "https://cdn.example.com/lib.js")
    }

    @Test("External URLs are never modified by assetPath", .publishingContext())
    func externalAssetPathNotModified() throws {
        let result = try withPublishingContext(for: TestRelativePathsSite()) { context in
            // assetPath only prepends site path for paths starting with /
            context.assetPath("https://cdn.example.com/lib.js")
        }

        #expect(result == "https://cdn.example.com/lib.js")
    }

    @Test("MetaLink with external URL is not modified", .publishingContext())
    func externalMetaLinkNotModified() throws {
        let output = try withPublishingContext(for: TestRelativePathsSite()) { _ in
            let metaLink = MetaLink(
                href: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css",
                rel: .stylesheet
            )
            return metaLink.markupString()
        }

        #expect(output.contains("href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css\""))
    }

    @Test("Script with external URL is not modified", .publishingContext())
    func externalScriptNotModified() throws {
        let output = try withPublishingContext(for: TestRelativePathsSite()) { _ in
            let externalURL = URL(string: "https://cdn.example.com/external.js")!
            let script = Script(file: externalURL)
            return script.markupString()
        }

        #expect(output.contains("src=\"https://cdn.example.com/external.js\""))
    }

    // MARK: - Paths Without Leading Slash Pass Through Unchanged

    @Test("Paths without leading slash pass through unchanged", .publishingContext())
    func pathsWithoutLeadingSlashUnchanged() throws {
        let result = try withPublishingContext(for: TestRelativePathsSite()) { context in
            // assetPath should not modify paths without leading slash
            context.assetPath("relative/path/file.css")
        }

        #expect(result == "relative/path/file.css")
    }

    @Test("Empty path is handled correctly", .publishingContext())
    func emptyPathHandled() throws {
        let result = try withPublishingContext(for: TestRelativePathsSite()) { context in
            context.assetPath("")
        }

        #expect(result == "")
    }

    // MARK: - Static MetaLink Constants

    @Test("MetaLink.standardCSS uses relative paths when enabled", .publishingContext())
    func standardCSSUsesRelativePaths() throws {
        let output = try withPublishingContext(for: TestRelativePathsSite()) { _ in
            MetaLink.standardCSS.markupString()
        }

        #expect(output.contains("href=\"css/bootstrap.min.css\""))
        #expect(!output.contains("href=\"/css/bootstrap.min.css\""))
    }

    @Test("MetaLink.iconCSS uses relative paths when enabled", .publishingContext())
    func iconCSSUsesRelativePaths() throws {
        let output = try withPublishingContext(for: TestRelativePathsSite()) { _ in
            MetaLink.iconCSS.markupString()
        }

        #expect(output.contains("href=\"css/bootstrap-icons.min.css\""))
        #expect(!output.contains("href=\"/css/bootstrap-icons.min.css\""))
    }

    @Test("MetaLink.igniteCoreCSS uses relative paths when enabled", .publishingContext())
    func igniteCoreCSSUsesRelativePaths() throws {
        let output = try withPublishingContext(for: TestRelativePathsSite()) { _ in
            MetaLink.igniteCoreCSS.markupString()
        }

        #expect(output.contains("href=\"css/ignite-core.min.css\""))
        #expect(!output.contains("href=\"/css/ignite-core.min.css\""))
    }

    @Test("Relative path images find local variants", .publishingContext())
    func relativePathImagesFindLocalVariants() throws {
        let directories = try makeTemporarySiteDirectories()
        defer {
            try? FileManager.default.removeItem(at: directories.rootDirectory)
        }

        try createImageVariants(in: directories.sourceDirectory)
        let context = try PublishingContext.initialize(
            for: TestRelativePathsSite(),
            sourceDirectory: directories.sourceDirectory,
            buildDirectory: directories.buildDirectory
        )

        PublishingContext.withCurrent(context) {
            let output = Image("/images/example.jpg", description: "Example image").markupString()

            #expect(output.contains("src=\"images/example.jpg\""))
            #expect(output.contains("srcset=\"images/example@2x.jpg 2x\""))
            #expect(!output.contains("src=\"/images/example.jpg\""))
            #expect(!context.warnings.contains("Could not read the assets directory. Please file a bug report."))
        }
    }

    @Test("Relative path image variants keep the subsite prefix", .publishingContext())
    func relativePathImageVariantsKeepSubsitePrefix() throws {
        let directories = try makeTemporarySiteDirectories()
        defer {
            try? FileManager.default.removeItem(at: directories.rootDirectory)
        }

        try createImageVariants(in: directories.sourceDirectory)
        let context = try PublishingContext.initialize(
            for: TestRelativePathsSubsite(),
            sourceDirectory: directories.sourceDirectory,
            buildDirectory: directories.buildDirectory
        )

        PublishingContext.withCurrent(context) {
            let output = Image("/images/example.jpg", description: "Example image").markupString()

            #expect(output.contains("src=\"subsite/images/example.jpg\""))
            #expect(output.contains("srcset=\"subsite/images/example@2x.jpg 2x\""))
            #expect(!context.warnings.contains("Could not read the assets directory. Please file a bug report."))
        }
    }

    // MARK: - useRelativePaths Defaults to False

    @Test("useRelativePaths defaults to false", .publishingContext())
    func useRelativePathsDefaultsToFalse() throws {
        let site = TestSite()
        #expect(site.useRelativePaths == false)
    }

    @Test("TestRelativePathsSite has useRelativePaths true", .publishingContext())
    func testRelativePathsSiteHasRelativePaths() throws {
        let site = TestRelativePathsSite()
        #expect(site.useRelativePaths == true)
    }

    private func makeTemporarySiteDirectories() throws -> (rootDirectory: URL, sourceDirectory: URL, buildDirectory: URL) {
        let rootDirectory = FileManager.default.temporaryDirectory
            .appending(path: UUID().uuidString)
        let sourceDirectory = rootDirectory.appending(path: "Source")
        let buildDirectory = rootDirectory.appending(path: "Build")

        try FileManager.default.createDirectory(
            at: sourceDirectory,
            withIntermediateDirectories: true
        )

        return (rootDirectory, sourceDirectory, buildDirectory)
    }

    private func createImageVariants(in sourceDirectory: URL) throws {
        let imagesDirectory = sourceDirectory.appending(path: "Assets/images")
        try FileManager.default.createDirectory(
            at: imagesDirectory,
            withIntermediateDirectories: true
        )

        try Data("base".utf8).write(to: imagesDirectory.appending(path: "example.jpg"))
        try Data("2x".utf8).write(to: imagesDirectory.appending(path: "example@2x.jpg"))
    }

    private func withPublishingContext<T>(
        for site: any Site,
        operation: (PublishingContext) throws -> T
    ) throws -> T {
        try PublishingContext.withInitialized(for: site, from: #filePath, operation: operation)
    }
}

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
@MainActor
struct RelativePathsTests {

    // MARK: - Default Behavior (useRelativePaths = false)

    @Test("Default behavior produces absolute paths with leading slash")
    func defaultBehaviorProducesAbsolutePaths() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
        let context = PublishingContext.shared

        // Test path(for:) with a local URL
        let localURL = URL(string: "/js/test.js")!
        let result = context.path(for: localURL)
        #expect(result == "/js/test.js")

        // Test assetPath with a local path
        let assetResult = context.assetPath("/css/styles.css")
        #expect(assetResult == "/css/styles.css")
    }

    @Test("Default behavior for MetaLink produces absolute paths")
    func defaultMetaLinkProducesAbsolutePaths() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)

        let metaLink = MetaLink(href: "/css/bootstrap.min.css", rel: .stylesheet)
        let output = metaLink.markupString()

        #expect(output.contains("href=\"/css/bootstrap.min.css\""))
    }

    @Test("Default behavior for Script produces absolute paths")
    func defaultScriptProducesAbsolutePaths() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)

        let script = Script(file: "/js/test.js")
        let output = script.markupString()

        #expect(output.contains("src=\"/js/test.js\""))
    }

    @Test("Default behavior for Link produces absolute paths")
    func defaultLinkProducesAbsolutePaths() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)

        let link = Link("Test", target: "/about")
        let output = link.markupString()

        #expect(output.contains("href=\"/about/\""))
    }

    // MARK: - Relative Paths Behavior (useRelativePaths = true)

    @Test("useRelativePaths strips leading slash from path(for:)")
    func relativePathsStripsLeadingSlash() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)
        let context = PublishingContext.shared

        let localURL = URL(string: "/js/test.js")!
        let result = context.path(for: localURL)

        #expect(result == "js/test.js")
    }

    @Test("useRelativePaths strips leading slash from assetPath")
    func relativeAssetPathStripsLeadingSlash() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)
        let context = PublishingContext.shared

        let result = context.assetPath("/css/styles.css")

        #expect(result == "css/styles.css")
    }

    @Test("useRelativePaths for MetaLink produces relative paths")
    func relativeMetaLinkProducesRelativePaths() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)

        let metaLink = MetaLink(href: "/css/bootstrap.min.css", rel: .stylesheet)
        let output = metaLink.markupString()

        #expect(output.contains("href=\"css/bootstrap.min.css\""))
        #expect(!output.contains("href=\"/css/bootstrap.min.css\""))
    }

    @Test("useRelativePaths for Script produces relative paths")
    func relativeScriptProducesRelativePaths() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)

        let script = Script(file: "/js/bootstrap.bundle.min.js")
        let output = script.markupString()

        #expect(output.contains("src=\"js/bootstrap.bundle.min.js\""))
        #expect(!output.contains("src=\"/js/bootstrap.bundle.min.js\""))
    }

    @Test("useRelativePaths for Link produces relative paths")
    func relativeLinkProducesRelativePaths() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)

        let link = Link("About", target: "/about")
        let output = link.markupString()

        #expect(output.contains("href=\"about/\""))
        #expect(!output.contains("href=\"/about/\""))
    }

    // MARK: - Subsite Support

    @Test("Subsite with default paths includes subsite prefix")
    func subsiteDefaultPathsIncludePrefix() throws {
        try PublishingContext.initialize(for: TestSubsite(), from: #filePath)
        let context = PublishingContext.shared

        // assetPath should include subsite prefix
        let result = context.assetPath("/css/styles.css")
        #expect(result == "/subsite/css/styles.css")
    }

    @Test("Subsite with relative paths includes subsite prefix without leading slash")
    func subsiteRelativePathsIncludePrefixWithoutSlash() throws {
        try PublishingContext.initialize(for: TestRelativePathsSubsite(), from: #filePath)
        let context = PublishingContext.shared

        // assetPath should include subsite prefix but no leading slash
        let result = context.assetPath("/css/styles.css")
        #expect(result == "subsite/css/styles.css")
    }

    @Test("Subsite MetaLink with relative paths produces correct output")
    func subsiteRelativeMetaLinkOutput() throws {
        try PublishingContext.initialize(for: TestRelativePathsSubsite(), from: #filePath)

        let metaLink = MetaLink(href: "/css/bootstrap.min.css", rel: .stylesheet)
        let output = metaLink.markupString()

        #expect(output.contains("href=\"subsite/css/bootstrap.min.css\""))
    }

    // MARK: - External URLs Should Not Be Modified

    @Test("External URLs are never modified by path(for:)")
    func externalURLsNotModified() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)
        let context = PublishingContext.shared

        let externalURL = URL(string: "https://cdn.example.com/lib.js")!
        let result = context.path(for: externalURL)

        #expect(result == "https://cdn.example.com/lib.js")
    }

    @Test("External URLs are never modified by assetPath")
    func externalAssetPathNotModified() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)
        let context = PublishingContext.shared

        // assetPath only prepends site path for paths starting with /
        let result = context.assetPath("https://cdn.example.com/lib.js")

        #expect(result == "https://cdn.example.com/lib.js")
    }

    @Test("MetaLink with external URL is not modified")
    func externalMetaLinkNotModified() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)

        let metaLink = MetaLink(
            href: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css",
            rel: .stylesheet
        )
        let output = metaLink.markupString()

        #expect(output.contains("href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css\""))
    }

    @Test("Script with external URL is not modified")
    func externalScriptNotModified() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)

        let externalURL = URL(string: "https://cdn.example.com/external.js")!
        let script = Script(file: externalURL)
        let output = script.markupString()

        #expect(output.contains("src=\"https://cdn.example.com/external.js\""))
    }

    // MARK: - Paths Without Leading Slash Pass Through Unchanged

    @Test("Paths without leading slash pass through unchanged")
    func pathsWithoutLeadingSlashUnchanged() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)
        let context = PublishingContext.shared

        // assetPath should not modify paths without leading slash
        let result = context.assetPath("relative/path/file.css")

        #expect(result == "relative/path/file.css")
    }

    @Test("Empty path is handled correctly")
    func emptyPathHandled() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)
        let context = PublishingContext.shared

        let result = context.assetPath("")

        #expect(result == "")
    }

    // MARK: - Static MetaLink Constants

    @Test("MetaLink.standardCSS uses relative paths when enabled")
    func standardCSSUsesRelativePaths() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)

        let output = MetaLink.standardCSS.markupString()

        #expect(output.contains("href=\"css/bootstrap.min.css\""))
        #expect(!output.contains("href=\"/css/bootstrap.min.css\""))
    }

    @Test("MetaLink.iconCSS uses relative paths when enabled")
    func iconCSSUsesRelativePaths() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)

        let output = MetaLink.iconCSS.markupString()

        #expect(output.contains("href=\"css/bootstrap-icons.min.css\""))
        #expect(!output.contains("href=\"/css/bootstrap-icons.min.css\""))
    }

    @Test("MetaLink.igniteCoreCSS uses relative paths when enabled")
    func igniteCoreCSSUsesRelativePaths() throws {
        try PublishingContext.initialize(for: TestRelativePathsSite(), from: #filePath)

        let output = MetaLink.igniteCoreCSS.markupString()

        #expect(output.contains("href=\"css/ignite-core.min.css\""))
        #expect(!output.contains("href=\"/css/ignite-core.min.css\""))
    }

    @Test("Relative path images find local variants")
    func relativePathImagesFindLocalVariants() throws {
        let directories = try makeTemporarySiteDirectories()
        defer {
            try? FileManager.default.removeItem(at: directories.rootDirectory)
        }

        try createImageVariants(in: directories.sourceDirectory)
        try PublishingContext.initialize(
            for: TestRelativePathsSite(),
            sourceDirectory: directories.sourceDirectory,
            buildDirectory: directories.buildDirectory
        )

        let output = Image("/images/example.jpg", description: "Example image").markupString()

        #expect(output.contains("src=\"images/example.jpg\""))
        #expect(output.contains("srcset=\"images/example@2x.jpg 2x\""))
        #expect(!output.contains("src=\"/images/example.jpg\""))
        #expect(!PublishingContext.shared.warnings.contains("Could not read the assets directory. Please file a bug report."))
    }

    @Test("Relative path image variants keep the subsite prefix")
    func relativePathImageVariantsKeepSubsitePrefix() throws {
        let directories = try makeTemporarySiteDirectories()
        defer {
            try? FileManager.default.removeItem(at: directories.rootDirectory)
        }

        try createImageVariants(in: directories.sourceDirectory)
        try PublishingContext.initialize(
            for: TestRelativePathsSubsite(),
            sourceDirectory: directories.sourceDirectory,
            buildDirectory: directories.buildDirectory
        )

        let output = Image("/images/example.jpg", description: "Example image").markupString()

        #expect(output.contains("src=\"subsite/images/example.jpg\""))
        #expect(output.contains("srcset=\"subsite/images/example@2x.jpg 2x\""))
        #expect(!PublishingContext.shared.warnings.contains("Could not read the assets directory. Please file a bug report."))
    }

    // MARK: - useRelativePaths Defaults to False

    @Test("useRelativePaths defaults to false")
    func useRelativePathsDefaultsToFalse() throws {
        let site = TestSite()
        #expect(site.useRelativePaths == false)
    }

    @Test("TestRelativePathsSite has useRelativePaths true")
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
}

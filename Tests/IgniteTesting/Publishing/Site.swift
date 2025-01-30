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
@Suite("Site Tests", .serialized)
@MainActor
struct SiteTests {
    
    private let package = TestPackage()
    
    @Test("Site published given there is no Markdown content")
    func publishingWithNoMarkdownContent() async throws {
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
        
        try FileManager.default.removeItem(at: markdownFileURL)
        try FileManager.default.removeItem(at: package.buildDirectoryURL)
    }
    
    @Test("Site published when Markdown content contains invalid lastModified date")
    func publishingWithInvalidLastModifiedDate() async throws {
        let markdownFileURL = package.contentDirectoryURL.appending(path: "story-with-invalid-lastModified.md")
        let markdownContent = """
        ---
        layout: TestStory
        lastModified: 2020-03-30 16:37:21
        ---
        
        # Story with invalid lastModified
        """
        
        try markdownContent.write(to: markdownFileURL, atomically: false, encoding: .utf8)
        
        try await TestSitePublisher().publish()
        
        #expect(package.checkIndexFileExists() == true)
        
        try FileManager.default.removeItem(at: markdownFileURL)
        try FileManager.default.removeItem(at: package.buildDirectoryURL)
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
}

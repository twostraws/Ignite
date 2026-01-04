//
// AppTargetPublishingTests.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for publishing with explicit directories (app target usage).
@Suite("App Target Publishing Tests")
@MainActor
struct AppTargetPublishingTests {
    /// Verifies that URL.makeDirectories creates directories from explicit URLs.
    @Test("makeDirectories succeeds with valid source directory")
    func makeDirectoriesWithValidSource() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appending(path: UUID().uuidString)
        let sourceDir = tempDir.appending(path: "Source")

        try FileManager.default.createDirectory(
            at: sourceDir,
            withIntermediateDirectories: true
        )

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let buildDir = tempDir.appending(path: "Build")
        let directories = try URL.makeDirectories(source: sourceDir, build: buildDir)

        #expect(directories.source == sourceDir)
        #expect(directories.build == buildDir)
    }

    /// Verifies that URL.makeDirectories throws missingSourceDirectory for non-existent path.
    @Test("makeDirectories throws missingSourceDirectory for missing source directory")
    func makeDirectoriesThrowsForMissingSource() throws {
        let nonExistent = URL(filePath: "/nonexistent/path/\(UUID().uuidString)")
        let buildDir = FileManager.default.temporaryDirectory

        #expect {
            try URL.makeDirectories(source: nonExistent, build: buildDir)
        } throws: { error in
            guard case PublishingError.missingSourceDirectory(let url) = error else {
                return false
            }
            return url == nonExistent
        }
    }

    /// Verifies that URL.makeDirectories throws missingSourceDirectory when source is a file.
    @Test("makeDirectories throws missingSourceDirectory when source is a file")
    func makeDirectoriesThrowsForFileSource() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appending(path: UUID().uuidString)
        let fileURL = tempDir.appending(path: "somefile.txt")

        try FileManager.default.createDirectory(
            at: tempDir,
            withIntermediateDirectories: true
        )
        try "test content".write(to: fileURL, atomically: true, encoding: .utf8)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let buildDir = tempDir.appending(path: "Build")

        #expect {
            try URL.makeDirectories(source: fileURL, build: buildDir)
        } throws: { error in
            guard case PublishingError.missingSourceDirectory(let url) = error else {
                return false
            }
            return url == fileURL
        }
    }

    /// Verifies that PublishingContext can be initialized with explicit directories.
    @Test("PublishingContext initializes with explicit directories")
    func contextInitializesWithExplicitDirectories() throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appending(path: UUID().uuidString)
        let sourceDir = tempDir.appending(path: "Source")
        let buildDir = tempDir.appending(path: "Build")

        try FileManager.default.createDirectory(
            at: sourceDir,
            withIntermediateDirectories: true
        )

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let site = TestSite()
        let context = try PublishingContext.initialize(
            for: site,
            sourceDirectory: sourceDir,
            buildDirectory: buildDir
        )

        #expect(context.sourceDirectory == sourceDir)
        #expect(context.buildDirectory == buildDir)
        #expect(context.assetsDirectory == sourceDir.appending(path: "Assets"))
        #expect(context.contentDirectory == sourceDir.appending(path: "Content"))
        #expect(context.includesDirectory == sourceDir.appending(path: "Includes"))
    }

    /// Verifies that PublishingContext throws missingSourceDirectory for non-existent path.
    @Test("PublishingContext throws missingSourceDirectory for missing source directory")
    func contextThrowsForMissingSource() throws {
        let nonExistent = URL(filePath: "/nonexistent/path/\(UUID().uuidString)")
        let buildDir = FileManager.default.temporaryDirectory

        let site = TestSite()

        #expect {
            try PublishingContext.initialize(
                for: site,
                sourceDirectory: nonExistent,
                buildDirectory: buildDir
            )
        } throws: { error in
            guard case PublishingError.missingSourceDirectory(let url) = error else {
                return false
            }
            return url == nonExistent
        }
    }

    /// Verifies the error message for missing source directory is descriptive.
    @Test("Missing source directory error has descriptive message")
    func missingSourceDirectoryErrorMessage() {
        let testPath = URL(filePath: "/test/missing/directory")
        let error = PublishingError.missingSourceDirectory(testPath)

        #expect(error.errorDescription?.contains("/test/missing/directory") == true)
        #expect(error.errorDescription?.contains("does not exist") == true)
        #expect(error.errorDescription?.contains("is not a directory") == true)
    }
}

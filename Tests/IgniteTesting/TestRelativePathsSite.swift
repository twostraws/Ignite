//
// TestRelativePathsSite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Ignite

/// A test site with useRelativePaths enabled for testing relative path generation.
struct TestRelativePathsSite: Site {
    var name = "My Test Site"
    var titleSuffix = " - My Test Site"
    var url = URL(static: "https://www.example.com")

    var builtInIconsEnabled: BootstrapOptions = .localBootstrap

    var homePage = TestPage()
    var layout = EmptyLayout()

    /// Enable relative paths for this test site
    var useRelativePaths: Bool { true }
}

/// A test subsite with useRelativePaths enabled.
struct TestRelativePathsSubsite: Site {
    var name = "My Test Subsite"
    var titleSuffix = " - My Test Subsite"
    var url = URL(static: "https://www.example.com/subsite")

    var builtInIconsEnabled: BootstrapOptions = .localBootstrap

    var homePage = TestSubsitePage()
    var layout = EmptyLayout()

    /// Enable relative paths for this test site
    var useRelativePaths: Bool { true }
}

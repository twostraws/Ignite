//
// TestSubsite.swift                                
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// An example site used in tests.
struct TestSubsite: Site {
    var name = "My Test Subsite"
    var titleSuffix = " - My Test Subsite"
    var url: URL = URL("https://www.yoursite.com/subsite")

    var builtInIconsEnabled: BootstrapOptions = .localBootstrap
    var syntaxHighlighters = [SyntaxHighlighter.objectiveC]

    var homePage = TestSubsitePage()
    var theme = EmptyTheme()

    var mapKitToken: String? = "eyJraWQiOiI0UkRRVVRIMjJOIiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiIyTVA4UVdLN1I2IiwiaWF0IjoxNzI1NTk4NDM2LCJvcmlnaW4iOiJpZ25pdGVzYW1wbGVzLmhhY2tpbmd3aXRoc3dpZnQuY29tIn0.UgaNnmSfiQsD6D23LC7-_5mEY2p_hvtM_nPOfwtV48UWl1YPX5o2YgvAJpTdjMzEQZ-IPapuIXJ7DJ4N4kdo8w"

    var mapKitLibraries: [Map.MapLibrary]? = [.map, .annotations, .services]
}

/// An example page  used in tests.
struct TestSubsitePage: StaticPage {
    var title = "Subsite Home"

    func body(context: PublishingContext) -> [any BlockElement] {
        Text("Example subsite text")
    }
}

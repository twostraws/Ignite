//
// TestSite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// An example site used in tests.
struct TestSite: Site {
    
    var mapKitLibraries: [Map.MapLibrary]? = [.map, .annotations, .services]

    var name = "My Test Site"
    var titleSuffix = " - My Test Site"
    var url: URL = URL("https://www.yoursite.com")

    var builtInIconsEnabled: BootstrapOptions = .localBootstrap
    var syntaxHighlighters = [SyntaxHighlighter.objectiveC]

    var mapKitToken: String? = "eyJraWQiOiI0UkRRVVRIMjJOIiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiIyTVA4UVdLN1I2IiwiaWF0IjoxNzI1NTk4NDM2LCJvcmlnaW4iOiJpZ25pdGVzYW1wbGVzLmhhY2tpbmd3aXRoc3dpZnQuY29tIn0.UgaNnmSfiQsD6D23LC7-_5mEY2p_hvtM_nPOfwtV48UWl1YPX5o2YgvAJpTdjMzEQZ-IPapuIXJ7DJ4N4kdo8w"

    var homePage = TestPage()
    var theme = EmptyTheme()
}

/// An example page  used in tests.
struct TestPage: StaticPage {
    var title = "Home"

    func body(context: PublishingContext) -> [any BlockElement] {
        Text("Example text")
    }
}

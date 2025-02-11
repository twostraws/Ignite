//
// NavigationBar.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `NavigationBar` element.
@Suite("Navigation Bar Tests")
@MainActor struct NavigationBarTests {

    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("Root Tag is Header")
    func headerTag() async throws {
        let element = NavigationBar()

        #expect(nil != element.render()
            .htmlTagWithCloseTag("header"))
    }

    @Test("Has Nav Tag Inside Header")
    func navTag() async throws {
        let element = NavigationBar()

        let header = try #require(element.render()
            .htmlTagWithCloseTag("header"))

        #expect(nil != header.contents.htmlTagWithCloseTag("nav"))
    }

    @Test("Nav Tag Class Is navbar and navbar-expand-md")
    func navTagClass() async throws {
        let element = NavigationBar()

        let navClasses = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.attributes
            .htmlAttribute(named: "class")?
            .components(separatedBy: " ")
        )

        let expected = ["navbar", "navbar-expand-md"]
        #expect(navClasses == expected)
    }

    @Test("Nav Tag Class data-bs-theme is blank if style is default")
    func navTagDefaultTheme() async throws {
        var element = NavigationBar()
        element.style = .default

        let navAttributes = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.attributes
        )

        #expect(nil == navAttributes.htmlAttribute(named: "data-bs-theme"))
    }

    @Test("Nav Tag Class data-bs-theme is dark if style is dark")
    func navTagDarkTheme() async throws {
        var element = NavigationBar()
        element.style = .dark

        let theme = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.attributes
            .htmlAttribute(named: "data-bs-theme")
        )

        let expected = "dark"
        #expect(theme == expected)
    }

    @Test("Nav Tag Class data-bs-theme is light if style is light")
    func navTagLightTheme() async throws {
        var element = NavigationBar()
        element.style = .light

        let theme = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.attributes
            .htmlAttribute(named: "data-bs-theme")
        )

        let expected = "light"
        #expect(theme == expected)
    }

    @Test("Has Div Tag Inside if given width", arguments: [
        NavigationBar.Width.viewport,
        .count(2),
        .count(10)
    ])
    func divTagForColumnWidth(width: NavigationBar.Width) async throws {
        let element = NavigationBar().width(width)

        let navContents = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
        )

        #expect(nil != navContents.htmlTagWithCloseTag("div"))
    }

    @Test("Div Tag Class contains column count if given column width", arguments: [0, 3, 7])
    func divTagClassBeginsWithColumnCount(columns: Int) async throws {
        let element = NavigationBar().width(.count(columns))

        let divClasses = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.attributes
            .htmlAttribute(named: "class")?
            .components(separatedBy: " ")
        )

        let expected = "col-md-\(columns)"
        #expect(divClasses.contains(expected))
    }

    @Test("Div Tag Class contains `container` if given column width", arguments: [
        NavigationBar.Width.count(2),
        .count(10)
    ])
    func divTagClassEndsWithContainer(width: NavigationBar.Width) async throws {
        let element = NavigationBar().width(width)

        let divClasses = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.attributes
            .htmlAttribute(named: "class")?
            .components(separatedBy: " ")
        )

        let expected = "container"
        #expect(divClasses.contains(expected))
    }

    @Test("Div Tag Class is as expected if given viewport width")
    func divTagClassIsFluid() async throws {
        let element = NavigationBar().width(.viewport)

        let divClasses = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.attributes
            .htmlAttribute(named: "class")?
            .components(separatedBy: " ")
        )

        let expected = "col container-fluid".components(separatedBy: " ")
        #expect(divClasses == expected)
    }

    @Test("Div Tag contains logo if given logo")
    func divTagContainsLogo() async throws {
        let logoImage = Image("")
        let element = NavigationBar(logo: logoImage)

        let divContents = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.contents
        )

        let expected = try Regex(logoImage.render())
        #expect(divContents.firstMatch(of: expected) != nil)
    }

    @Test("Div contains render toggle button if items is not empty")
    func divTagContainsToggleButton() async throws {
        let element = NavigationBar(logo: Image("somepath")) {
            Link("Link 1", target: URL(string: "1")!)
        }

        let divContents = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.contents
        )

        let expected = """
<button type="button"\
 class="btn navbar-toggler"\
 data-bs-target="#navbarCollapse"\
 data-bs-toggle="collapse" aria-controls="navbarCollapse"\
 aria-expanded="false" aria-label="Toggle navigation">\
<span class="navbar-toggler-icon"></span></button>
"""
        #expect(divContents.contains(expected))
    }

    @Test("Div Tag contains unordered list if items is not nil")
    func divTagContainsUL() async throws {
        let item = Link("Link 1", target: URL(string: "1")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item
        }

        let divContents = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.contents
        )

        #expect(nil != divContents.htmlTagWithCloseTag("ul"))
    }

    @Test("Unordered List omits alignment if default")
    func ulTagClassDoesNotContainAignmentIfDefault() async throws {
        let item = Link("Link 1", target: URL(string: "1")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item
        }

        let ulAttributes = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.contents
            .htmlTagWithCloseTag("ul")?.attributes
        )

        let expected = "justify-content"
        #expect(!ulAttributes.contains(expected))
    }

    @Test("Unordered List contains trailing alignment if set")
    func ulTagClassContainCenterAignmentIfGiven() async throws {
        let item = Link("Link 1", target: URL(string: "1")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item
        }
            .navigationItemAlignment(.center)

        let ulClasses = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.contents
            .htmlTagWithCloseTag("ul")?.attributes
            .htmlAttribute(named: "class")
        )

        let expected = "justify-content-center"
        #expect(ulClasses.contains(expected))
    }

    @Test("Unordered List contains trailing alignment if set")
    func ulTagClassContainTrailingAignmentIfGiven() async throws {
        let item = Link("Link 1", target: URL(string: "1")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item
        }
            .navigationItemAlignment(.trailing)

        let ulClasses = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.contents
            .htmlTagWithCloseTag("ul")?.attributes
            .htmlAttribute(named: "class")
        )

        let expected = "justify-content-end"
        #expect(ulClasses.contains(expected))
    }

    @Test("UL Tag contains rendered output of item")
    func divTagContainsRenderedItem() async throws {
        let item = Link("Link 1", target: URL(string: "1")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item
        }

        let ulContents = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.contents
            .htmlTagWithCloseTag("ul")?.contents
        )

        let expected = item.render()
        #expect(ulContents.contains(expected))
    }

    @Test("UL Tag contains rendered output of items")
    func divTagContainsRenderedItems() async throws {
        let item1 = Link("Link 1", target: URL(string: "1")!)
        let item2 = Link("Link 2", target: URL(string: "2")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item1
            item2
        }

        let ulContents = try #require(element.render()
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.contents
            .htmlTagWithCloseTag("ul")?.contents
        )

        #expect(ulContents.contains(item1.render()))
        #expect(ulContents.contains(item2.render()))
    }
}

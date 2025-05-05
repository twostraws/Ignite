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
class NavigationBarTests: IgniteTestSuite {
    @Test("Root Tag is Header")
    func headerTag() async throws {
        let element = NavigationBar()
        let output = element.markupString()

        #expect(output.htmlTagWithCloseTag("header") != nil)
    }

    @Test("Has Nav Tag Inside Header")
    func navTag() async throws {
        let element = NavigationBar()
        let output = element.markupString()

        let header = try #require(output
            .htmlTagWithCloseTag("header"))

        #expect(header.contents.htmlTagWithCloseTag("nav") != nil)
    }

    @Test("Nav Tag Class Is navbar and navbar-expand-md")
    func navTagClass() async throws {
        let element = NavigationBar()
        let output = element.markupString()

        let navClasses = try #require(output
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
        let element = NavigationBar()
        let output = element.markupString()

        let navAttributes = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.attributes
        )

        #expect(navAttributes.htmlAttribute(named: "data-bs-theme") == nil)
    }

    @Test("Nav Tag Class data-bs-theme is dark if style is dark")
    func navTagDarkTheme() async throws {
        let element = NavigationBar().navigationBarStyle(.dark)
        let output = element.markupString()

        let theme = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.attributes
            .htmlAttribute(named: "data-bs-theme")
        )

        let expected = "dark"
        #expect(theme == expected)
    }

    @Test("Nav Tag Class data-bs-theme is light if style is light")
    func navTagLightTheme() async throws {
        let element = NavigationBar().navigationBarStyle(.light)
        let output = element.markupString()

        let theme = try #require(output
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
        let output = element.markupString()

        let navContents = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
        )

        #expect(navContents.htmlTagWithCloseTag("div") != nil)
    }

    @Test("Div Tag Class contains column count if given column width", arguments: [0, 3, 7])
    func divTagClassBeginsWithColumnCount(columns: Int) async throws {
        let element = NavigationBar().width(.count(columns))
        let output = element.markupString()

        let divClasses = try #require(output
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
        let output = element.markupString()

        let divClasses = try #require(output
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
        let output = element.markupString()

        let divClasses = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.attributes
            .htmlAttribute(named: "class")?
            .components(separatedBy: " ")
        )

        let expected = "container-fluid col flex-wrap flex-lg-nowrap".components(separatedBy: " ")
        #expect(divClasses == expected)
    }

    @Test("Div Tag contains logo if given logo")
    func divTagContainsLogo() async throws {
        let logoImage = Image("")
        let element = NavigationBar(logo: logoImage)
        let output = element.markupString()

        let divContents = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("div")?.contents
        )

        let expected = try Regex(logoImage.markupString())
        #expect(divContents.firstMatch(of: expected) != nil)
    }

    @Test("Div contains render toggle button if items is not empty")
    func divTagContainsToggleButton() async throws {
        let element = NavigationBar(logo: Image("somepath")) {
            Link("Link 1", target: URL(string: "1")!)
        }
        let output = element.markupString()

        let navContents = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents)

        #expect(navContents.contains("""
        <button type="button" \
        class="navbar-toggler btn" \
        data-bs-toggle="collapse" \
        data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" \
        aria-expanded="false" aria-label="Toggle navigation">\
        <span class="navbar-toggler-icon"></span></button>
        """))
    }

    @Test("Div Tag contains unordered list if items is not nil")
    func divTagContainsUL() async throws {
        let item = Link("Link 1", target: URL(string: "1")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item
        }
        let output = element.markupString()

        let divContents = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents)

        #expect(divContents.htmlTagWithCloseTag("ul") != nil)
    }

    @Test("Unordered List contains trailing alignment if set")
    func ulTagClassContainCenterAignmentIfGiven() async throws {
        let item = Link("Link 1", target: URL(string: "1")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item
        }
        .navigationItemAlignment(.center)
        let output = element.markupString()

        let ulClasses = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("ul")?.attributes
            .htmlAttribute(named: "class"))

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
        let output = element.markupString()

        let ulClasses = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("ul")?.attributes
            .htmlAttribute(named: "class"))

        let expected = "justify-content-end"
        #expect(ulClasses.contains(expected))
    }

    @Test("UL Tag contains rendered output of navigation item")
    func divTagContainsRenderedItem() async throws {
        let item = Link("Link 1", target: URL(string: "1")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item
        }
        let output = element.markupString()

        let ulContents = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("ul")?.contents)

        let expectedLink = item
            .class("nav-link text-nowrap")
            .markup()
            .string
        let expectedNavItem = "<li class=\"nav-item\">\(expectedLink)</li>"

        #expect(ulContents.contains(expectedNavItem))
    }

    @Test("UL Tag contains rendered output of navigation items")
    func divTagContainsRenderedItems() async throws {
        let item1 = Link("Link 1", target: URL(string: "1")!)
        let item2 = Link("Link 2", target: URL(string: "2")!)
        let element = NavigationBar(logo: Image("somepath")) {
            item1
            item2
        }
        let output = element.markupString()

        let ulContents = try #require(output
            .htmlTagWithCloseTag("header")?.contents
            .htmlTagWithCloseTag("nav")?.contents
            .htmlTagWithCloseTag("ul")?.contents)

        let expectedLink1 = item1
            .class("nav-link text-nowrap")
            .markup()
            .string
        let expectedNavItem1 = "<li class=\"nav-item\">\(expectedLink1)</li>"

        let expectedLink2 = item2
            .class("nav-link text-nowrap")
            .markup()
            .string
        let expectedNavItem2 = "<li class=\"nav-item\">\(expectedLink2)</li>"

        #expect(ulContents.contains(expectedNavItem1))
        #expect(ulContents.contains(expectedNavItem2))
    }
}

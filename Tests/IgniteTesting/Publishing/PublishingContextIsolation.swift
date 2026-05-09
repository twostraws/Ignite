//
// PublishingContextIsolation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

private struct ContextIsolationRedStyle: Style {
    func style(content: StyledHTML, environment: EnvironmentConditions) -> StyledHTML {
        content.style(.color, "red")
    }
}

private struct ContextIsolationBlueStyle: Style {
    func style(content: StyledHTML, environment: EnvironmentConditions) -> StyledHTML {
        content.style(.color, "blue")
    }
}

/// Tests for task-local publishing state isolation.
@Suite("PublishingContext Isolation Tests")
struct PublishingContextIsolationTests {
    @Test("Publishing contexts keep registries isolated")
    func publishingContextsKeepRegistriesIsolated() throws {
        let firstContext = try PublishingContext.initialize(for: TestSite(), from: #filePath)
        let secondContext = try PublishingContext.initialize(for: TestSite(), from: #filePath)
        let firstFont = Font.custom("FirstContextFont", size: .px(12))
        let secondFont = Font.custom("SecondContextFont", size: .px(18))
        let firstStyle = ContextIsolationRedStyle()
        let secondStyle = ContextIsolationBlueStyle()

        let firstOutput = PublishingContext.withCurrent(firstContext) {
            Text("First")
                .font(firstFont)
                .style(firstStyle)
                .markupString()
        }

        let secondOutput = PublishingContext.withCurrent(secondContext) {
            Text("Second")
                .font(secondFont)
                .style(secondStyle)
                .markupString()
        }

        #expect(firstOutput.contains("First"))
        #expect(secondOutput.contains("Second"))
        #expect(firstContext.cssManager !== secondContext.cssManager)
        #expect(firstContext.styleManager !== secondContext.styleManager)
        #expect(firstContext.animationManager !== secondContext.animationManager)
        #expect(firstContext.cssManager.customFonts.contains(firstFont))
        #expect(!firstContext.cssManager.customFonts.contains(secondFont))
        #expect(secondContext.cssManager.customFonts.contains(secondFont))
        #expect(!secondContext.cssManager.customFonts.contains(firstFont))
        #expect(firstContext.styleManager.containsRegisteredStyle(named: firstStyle.className))
        #expect(!firstContext.styleManager.containsRegisteredStyle(named: secondStyle.className))
        #expect(secondContext.styleManager.containsRegisteredStyle(named: secondStyle.className))
        #expect(!secondContext.styleManager.containsRegisteredStyle(named: firstStyle.className))
    }

    @Test("Task-local contexts isolate concurrent renders")
    func taskLocalContextsIsolateConcurrentRenders() async throws {
        let firstContext = try PublishingContext.initialize(for: TestSite(), from: #filePath)
        let secondContext = try PublishingContext.initialize(for: TestSite(), from: #filePath)
        let firstFont = Font.custom("ConcurrentFirstFont", size: .px(14))
        let secondFont = Font.custom("ConcurrentSecondFont", size: .px(16))
        let firstStyle = ContextIsolationRedStyle()
        let secondStyle = ContextIsolationBlueStyle()

        async let firstOutput: String = PublishingContext.withCurrent(firstContext) {
            Text("First")
                .font(firstFont)
                .style(firstStyle)
                .markupString()
        }

        async let secondOutput: String = PublishingContext.withCurrent(secondContext) {
            Text("Second")
                .font(secondFont)
                .style(secondStyle)
                .markupString()
        }

        let outputs = await (firstOutput, secondOutput)

        #expect(outputs.0.contains("First"))
        #expect(outputs.1.contains("Second"))
        #expect(firstContext.cssManager.customFonts.contains(firstFont))
        #expect(!firstContext.cssManager.customFonts.contains(secondFont))
        #expect(secondContext.cssManager.customFonts.contains(secondFont))
        #expect(!secondContext.cssManager.customFonts.contains(firstFont))
        #expect(firstContext.styleManager.containsRegisteredStyle(named: firstStyle.className))
        #expect(!firstContext.styleManager.containsRegisteredStyle(named: secondStyle.className))
        #expect(secondContext.styleManager.containsRegisteredStyle(named: secondStyle.className))
        #expect(!secondContext.styleManager.containsRegisteredStyle(named: firstStyle.className))
    }

    @Test("Nested environments restore when scopes exit")
    func nestedEnvironmentsRestoreWhenScopesExit() throws {
        let context = try PublishingContext.initialize(for: TestSite(), from: #filePath)

        let observed = PublishingContext.withCurrent(context) {
            let outerEnvironment = environment(title: "Outer", context: context)
            let innerEnvironment = environment(title: "Inner", context: context)

            return context.withEnvironment(outerEnvironment) {
                let outerBefore = PublishingContext.shared.environment.page.title

                let inner = context.withEnvironment(innerEnvironment) {
                    PublishingContext.shared.environment.page.title
                }

                let outerAfter = PublishingContext.shared.environment.page.title

                return [outerBefore, inner, outerAfter]
            }
        }

        #expect(observed == ["Outer", "Inner", "Outer"])
    }

    @Test("Switching contexts clears the previous environment")
    func switchingContextsClearsPreviousEnvironment() throws {
        let firstContext = try PublishingContext.initialize(for: TestSite(), from: #filePath)
        let secondContext = try PublishingContext.initialize(for: TestSite(), from: #filePath)

        let observed = PublishingContext.withCurrent(firstContext) {
            let firstEnvironment = environment(title: "First", context: firstContext)

            return firstContext.withEnvironment(firstEnvironment) {
                let beforeSwitch = PublishingContext.shared.environment.page.title

                let duringSwitch = PublishingContext.withCurrent(secondContext) {
                    PublishingContext.shared.environment.page.title
                }

                let afterSwitch = PublishingContext.shared.environment.page.title

                return [beforeSwitch, duringSwitch, afterSwitch]
            }
        }

        #expect(observed == ["First", "", "First"])
    }

    private func environment(title: String, context: PublishingContext) -> EnvironmentValues {
        EnvironmentValues(
            sourceDirectory: context.sourceDirectory,
            site: context.site,
            allContent: context.allContent,
            pageMetadata: PageMetadata(
                title: title,
                description: "",
                url: URL(string: "https://example.com/\(title.lowercased())")!
            ),
            pageContent: context.site.homePage
        )
    }
}

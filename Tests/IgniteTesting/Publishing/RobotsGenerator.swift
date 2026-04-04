//
// RobotsGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// A test site with configurable robots rules.
private struct RobotsTestSite: Site {
    var name = "My Test Site"
    var url = URL(static: "https://www.example.com")
    var homePage = TestPage()
    var layout = EmptyLayout()
    var robotsConfiguration: TestRobotsConfig

    init(rules: [DisallowRule] = []) {
        self.robotsConfiguration = TestRobotsConfig(disallowRules: rules)
    }
}

private struct TestRobotsConfig: RobotsConfiguration {
    var disallowRules: [DisallowRule]
}

/// Tests for the `RobotsGenerator` output formatting.
@Suite("RobotsGenerator Tests")
@MainActor
struct RobotsGeneratorTests {
    @Test("Default configuration produces standard robots.txt")
    func defaultConfiguration() {
        let site = RobotsTestSite()
        let generator = RobotsGenerator(site: site)
        let output = generator.generateRobots()

        #expect(output == """
        User-agent: *
        Allow: /

        Sitemap: https://www.example.com/sitemap.xml
        """)
    }

    @Test("Single disallow rule with default wildcard path")
    func singleDisallowRule() {
        let site = RobotsTestSite(rules: [
            DisallowRule(name: "BadBot")
        ])
        let generator = RobotsGenerator(site: site)
        let output = generator.generateRobots()

        #expect(output.contains("User-agent: BadBot"))
        #expect(output.contains("Disallow: *"))
        #expect(output.contains("User-agent: *\nAllow: /"))
    }

    @Test("Disallow rule with specific paths")
    func disallowRuleWithPaths() {
        let site = RobotsTestSite(rules: [
            DisallowRule(name: "Googlebot", paths: ["/private", "/admin"])
        ])
        let generator = RobotsGenerator(site: site)
        let output = generator.generateRobots()

        #expect(output.contains("User-agent: Googlebot"))
        #expect(output.contains("Disallow: /private"))
        #expect(output.contains("Disallow: /admin"))
    }

    @Test("Multiple disallow rules are all included")
    func multipleDisallowRules() {
        let site = RobotsTestSite(rules: [
            DisallowRule(name: "BadBot"),
            DisallowRule(name: "AnotherBot", paths: ["/secret"])
        ])
        let generator = RobotsGenerator(site: site)
        let output = generator.generateRobots()

        #expect(output.contains("User-agent: BadBot"))
        #expect(output.contains("User-agent: AnotherBot"))
        #expect(output.contains("Disallow: /secret"))
    }

    @Test("Known robot disallow rule uses correct name")
    func knownRobotDisallowRule() {
        let site = RobotsTestSite(rules: [
            DisallowRule(robot: .chatGPT)
        ])
        let generator = RobotsGenerator(site: site)
        let output = generator.generateRobots()

        #expect(output.contains("User-agent: \(KnownRobot.chatGPT.rawValue)"))
    }

}

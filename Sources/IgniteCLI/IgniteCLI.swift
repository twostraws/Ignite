//
// IgniteCLI.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import ArgumentParser
import Foundation

/// The main entry point for our tool. This points users to one
/// of the subcommands.
@main
struct IgniteCLI: ParsableCommand {
    static let discussion = """
    Example usages:
        ignite new MySite – create a new site called MySite.
        ignite build - flattens the current site to HTML.
        ignite run – runs the current site in a local web server.
        ignite run --preview – runs the current site in a local web server, and opens it in your web browser.
        ignite run --force - automatically kills any existing local web server before launching a new one.
    """

    static let configuration = CommandConfiguration(
        commandName: "ignite",
        abstract: "A command-line tool for manipulating Ignite sites.",
        discussion: discussion,
        version: "0.2.0",
        subcommands: [NewCommand.self, BuildCommand.self, RunCommand.self]
    )
}

//
// BuildCommand.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import ArgumentParser
import Foundation

/// The command responsible for converting their site
/// code to HTML.
struct BuildCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "build",
        abstract: "Builds all the HTML for the current site."
    )

    /// Runs this command. Automatically called by Argument Parser.
    func run() throws {
        // Ensure we're in a valid directory.
        guard FileManager.default.fileExists(atPath: "./Package.swift") else {
            print("❌ Can't find Package.swift in the current directory.")
            return
       }

        print("⚙️  Building your site...")
        let (_, error) = try Process.execute(command: "swift run")

        // If something went wrong, print a message then
        // bail out.
        if error.contains("error:") {
            print(error)

            print("")
            print("❌ Failed to build.")
            return
        } else if error.contains("warning:") {
            // Warnings can just be printed; they won't hold
            // up a successful build.
            print(error)
        }

        print("✅ Successfully built!")
    }
}

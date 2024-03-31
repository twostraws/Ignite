//
// RunCommand.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import ArgumentParser
import Foundation

/// The command that lets users run their Ignite site
/// back in a local web server.
struct RunCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "run",
        abstract: "Start a local web server for the current site."
    )

    /// The server's port number. Defaults to 8000.
    @Option(name: .shortAndLong, help: "The port number to run the local server on.")
    var port = 8000

    /// The name of the site's output directory. Defaults to Build.
    @Option(name: .shortAndLong, help: "The name of your build directory.")
    var directory = "Build"

    /// Whether to open a web browser pointing at the local
    /// web server. Defaults to false.
    @Flag(help: "Whether to open the server in your preferred web browser immediately.")
    var preview = false

    /// Whether to automatically terminate any existing web
    /// server running on the port, if there is one. Defaults to false.
    @Flag(help: "Whether to force quit any existing server on the current port number before starting a new one.")
    var force = false

    /// Runs this command. Automatically called by Argument Parser.
    func run() throws {
        // Immediately kill any server if applicable, but only
        // if they asked us to.
        if force {
            try terminateAnyExistingServer()
        }

        // If we're still here and a server is already running
        // on their current port, we can't proceed.
        guard try isServerRunning() == false else {
            print("❌ A local web server is already running on port \(port).")
            return
        }

        // Make sure we actually have a folder to serve up.
        guard FileManager.default.fileExists(atPath: "./\(directory)") else {
            print("❌ Failed to find directory named '\(directory)'.")
            return
        }

        print("✅ Starting local web server on http://localhost:\(port)")
        print("Press ↵ Return to exit.")

        let previewCommand: String

        // Automatically open a web browser pointing to their
        // local server if requested.
        if preview {
            previewCommand = "open http://localhost:\(port)"
        } else {
            // Important: The empty space below is enough to
            // make the Process.execute() wait for a key press
            // before exiting.
            previewCommand = " "
        }

        try Process.execute(
            command: "python3 -m http.server -d \(directory) \(port)",
            then: previewCommand
        )
    }

    /// Locates and terminates any server running on the user's port.
    private func terminateAnyExistingServer() throws {
        if try isServerRunning() {
            let pid = try getRunningServerPID()
            try Process.execute(command: "kill \(pid)")
        }
    }

    /// Finds the process ID for any server running on the user's port.
    /// - Returns: The process ID (PID) for the server, or empty/
    private func getRunningServerPID() throws -> String {
        let result = try Process.execute(command: "lsof -t -i tcp:\(port)")
        return result.output
    }

    /// Returns true if there is a server running on the user's port.
    /// - Returns: True if there is a server running there, otherwise false.
    private func isServerRunning() throws -> Bool {
        try getRunningServerPID().isEmpty == false
    }
}

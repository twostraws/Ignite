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

    /// Runs this command. Automatically called by Argument Parser.
    func run() throws {
        // Make sure we actually have a folder to serve up.
        guard FileManager.default.fileExists(atPath: "./\(directory)") else {
            print("❌ Failed to find directory named '\(directory)'.")
            return
        }

        // Check for a subsite by not finding «href="/css/» in index.html.
        if let indexData = FileManager.default.contents(atPath: "\(directory)/index.html") {
            let indexString = String(decoding: indexData, as: UTF8.self)
            guard indexString.contains("<link href=\"/css") else {
                print("❌ This site specifies a custom subfolder, so it can't be previewed locally.")
                return
            }
        }

        // Find an available port
        var currentPort = port
        while try isServerRunning(on: currentPort) {
            currentPort += 1
            if currentPort >= 9000 {
                print("❌ No available ports found in range 8000-8999.")
                return
            }
        }

        print("✅ Starting local web server on http://localhost:\(currentPort)")
        print("Press ↵ Return to exit.")

        let previewCommand =
            if preview {
                // Automatically open a web browser pointing to their
                // local server if requested.
                "open http://localhost:\(currentPort)"
            } else {
                // Important: The empty space below is enough to
                // make the Process.execute() wait for a key press
                // before exiting.
                " "
            }

        // Get the installed location of the server script
        let serverScriptURL = URL(filePath: "/usr/local/bin/ignite-server.py")

        // Verify server script exists
        guard FileManager.default.fileExists(atPath: serverScriptURL.path) else {
            print("❌ Critical server component missing")
            print("   This suggests a corrupted installation. Please reinstall with:")
            print("   make install && make clean")
            return
        }

        print("✅ Starting local web server on http://localhost:\(currentPort)")
        try Process.execute(
            command: "python3 \(serverScriptURL.path) -d \(directory) \(currentPort)",
            then: previewCommand
        )
    }

    /// Returns true if there is a server running on the specified port.
    private func isServerRunning(on port: Int) throws -> Bool {
        let result = try Process.execute(command: "lsof -t -i tcp:\(port)")
        return !result.output.isEmpty
    }
}

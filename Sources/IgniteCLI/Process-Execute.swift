//
// Process-Execute.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A Process extension that knows how to run a command and
/// return its result. To make things easier, this also knows how
/// to execute a subsequent command while the first one is
/// running, which is important for previewing on a local server.
///
/// Important: This runs all commands through `/bin/bash -c`,
/// which allows us to `kill` a specific process ID belonging
/// to the user.
extension Process {
    /// Runs a command, optionally followed by a second command.
    /// - Parameters:
    ///   - arguments: The full command to execute. This must be passed as a string
    ///   even though an array might seem better, because `bash -c` executes the
    ///   command as the current user, and that also needs the whole command to be
    ///   passed as a single string rather than an array that is more common.
    ///   - subsequentCommand: A second command to run. Used when previewing the
    ///   local site in a web browser.
    /// - Returns: The contents of stdout and stderr as a tuple.
    @discardableResult
    static func execute(
        command: String,
        then subsequentCommand: String = ""
    ) throws -> (output: String, error: String) {
        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c"] + [command]

        let output = Pipe()
        let error = Pipe()
        process.standardOutput = output
        process.standardError = error

        Task {
            try process.run()
        }

        // If we have anything in a subsequent command,
        // run it now then wait for the main process
        // to terminate. This is why the empty string
        // is important for previewing a local server:
        // it triggers the functionality below!
        if subsequentCommand.isEmpty == false {
            Task {
                // Add a tiny pause to make sure the first command
                // is up and running before we launch the next
                // command.

                try await Task.sleep(for: .seconds(1))
                try Process.execute(command: subsequentCommand)
            }

            _ = readLine()
            process.terminate()
        }

        // Read all the stdout and stderr text and
        // send it back.
        let outputData = output.fileHandleForReading.readDataToEndOfFile()
        let errorData = error.fileHandleForReading.readDataToEndOfFile()

        let outputString = String(decoding: outputData, as: UTF8.self)
        let errorString = String(decoding: errorData, as: UTF8.self)

        return (outputString, errorString)
    }
}

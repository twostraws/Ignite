//
// Project: Ignite
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Errors that can be thrown by the `Server` struct.
public enum ServerError: LocalizedError {

    /// Indicates that the server is already running on the specified port.
    case serverAlreadyRunning

    /// Indicates a failure to execute an AppleScript, including the error message.
    case appleScriptExecutionFailed(String)

    public var errorDescription: String? {
        switch self {
            case .serverAlreadyRunning:
                "Server is already running"
            case .appleScriptExecutionFailed(let message):
                "AppleScript failed to execute. Error message: \(message)"
        }
    }
}

/// Represents a server that can serve content from a directory over HTTP.
public struct Server {

    /// The port on which the server should run.
    public let port: Int

    /// The file URL of the directory whose contents should be served.
    public let directoryPath: URL

    /// The path of the directory as a string, with spaces escaped for shell commands.
    private let directory: String

    /// Initializes a new server with the given port and directory path.
    ///
    /// - Parameters:
    ///   - port: The port on which to serve the directory's contents.
    ///   - directoryPath: The file URL of the directory to serve.
    public init(port: Int, directoryPath: URL) {
        self.port = port
        self.directoryPath = directoryPath
        self.directory = directoryPath.path(percentEncoded: false).escapingSpaces
    }

    /// Starts the server, throwing an error if it cannot start.
    ///
    /// This method attempts to start serving the contents of `directoryPath` over HTTP on `port`.
    /// If the server is already running on that port, or if there's an issue with the AppleScript
    /// execution, it throws an appropriate error.
    ///
    /// - Throws: A `ServerError` indicating why the server could not be started.
    public func start() throws {
        guard !isServerRunning(onPort: port) else {
            throw ServerError.serverAlreadyRunning
        }

        let command = "cd \(directory) && python3 -m http.server \(port)"
        let script = """
        tell application "Terminal"
            do script "\(command)"
            activate
        end tell

        delay 2

        tell application "System Events"
            open location "http://localhost:\(port)/"
        end tell
        """

        try runAppleScript(script)
        print("Server started at http://localhost:\(port)/")
    }

    /// Checks whether a server is already running on the specified port.
    ///
    /// - Parameter port: The port to check.
    /// - Returns: `true` if a server is already running on `port`, otherwise `false`.
    private func isServerRunning(onPort port: Int) -> Bool {
        let process = Process()
        let pipe = Pipe()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", "lsof -i tcp:\(port)"]
        process.standardOutput = pipe
        process.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: data, as: UTF8.self)
        return !output.isEmpty
    }

    /// Executes an AppleScript command.
    ///
    /// - Parameter script: The AppleScript command to execute.
    /// - Throws: `ServerError.appleScriptExecutionFailed` if the script fails to execute.
    private func runAppleScript(_ script: String) throws {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                let errorMessage = error[NSLocalizedDescriptionKey] as? String ?? "Unknown error"
                throw ServerError.appleScriptExecutionFailed(errorMessage)
            }
        }
    }
}

fileprivate extension String {

    /// Escapes spaces in the string for use in shell commands.
    var escapingSpaces: String {
        self.replacingOccurrences(of: " ", with: "\\ ")
    }
}

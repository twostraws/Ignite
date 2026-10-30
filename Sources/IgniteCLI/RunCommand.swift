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

        // Detect if the site is an subsite
        let subsite = identifySubsite(directory: directory) ?? ""

        // Find an available port
        var currentPort = port
        while try isServerRunning(on: currentPort) {
            currentPort += 1
            if currentPort >= 9000 {
                print("❌ No available ports found in range 8000-8999.")
                return
            }
        }

        let previewCommand =
            if preview {
                // Automatically open a web browser pointing to their
                // local server if requested.
                "open http://localhost:\(currentPort)\(subsite)"
            } else {
                // Important: The empty space below is enough to
                // make the Process.execute() wait for a key press
                // before exiting.
                " "
            }

        // Find the server script installed alongside the tool itself
        guard let serverScriptURL = locateServerScript() else {
            print("❌ Critical server script missing: ignite-server.py")
            print("   This suggests a corrupted installation. Please reinstall with:")
            print("   make clean && make install")
            print("   or, if you installed with Homebrew:")
            print("   brew reinstall ignite-swift")
            return
        }

        print("✅ Starting local web server on http://localhost:\(currentPort)\(subsite)")

        generateQRCode(port: currentPort, subsite: subsite)

        print("Press ↵ Return to exit.")

        let subsiteArgument = subsite.isEmpty ? "" : "-s \(subsite)"
        try Process.execute(
            command: "python3 \"\(serverScriptURL.path)\" -d \(directory) \(subsiteArgument) \(currentPort)",
            then: previewCommand
        )
    }

    /// Finds `ignite-server.py`, checking next to the executable (as installed
    /// by `make install`), then next to the executable with symlinks resolved,
    /// then in a sibling `libexec` folder (as installed by Homebrew).
    private func locateServerScript() -> URL? {
        let scriptName = "ignite-server.py"
        var executableURLs = [URL]()

        if let executableURL = Bundle.main.executableURL {
            executableURLs.append(executableURL)
            executableURLs.append(executableURL.resolvingSymlinksInPath())
        }

        let invokedPath = ProcessInfo.processInfo.arguments.first ?? ""
        if invokedPath.contains("/") {
            executableURLs.append(URL(filePath: invokedPath))
        }

        let candidates = executableURLs.flatMap { executableURL in
            let toolDirectory = executableURL.deletingLastPathComponent()
            return [
                toolDirectory.appending(path: scriptName),
                toolDirectory.deletingLastPathComponent().appending(path: "libexec/\(scriptName)")
            ]
        }

        return candidates.first { FileManager.default.fileExists(atPath: $0.path) }
    }

    /// Returns true if there is a server running on the specified port.
    private func isServerRunning(on port: Int) throws -> Bool {
        let result = try Process.execute(command: "lsof -t -i tcp:\(port)")
        return !result.output.isEmpty
    }

    /// Generates a QR code for the given URL and prints it to the terminal.
    private func generateQRCode(port: Int, subsite: String) {
        #if canImport(CoreImage)
        guard let ipAddress = getLocalIPAddress() else { return }
        let localURL = "http://\(ipAddress):\(port)\(subsite)"
        guard let qrCode = try? QRCode(utf8String: localURL) else { return }
        print("\n📱 Scan this QR code to access the site on your mobile device:\n")
        print(qrCode.smallAsciiRepresentation())
        print("URL: \(localURL)\n")
        #endif
    }

    /// Returns the local IP address of the machine.
    private func getLocalIPAddress() -> String? {
        var localIPAddress: String?
        var interfaceAddressPointer: UnsafeMutablePointer<ifaddrs>?

        if getifaddrs(&interfaceAddressPointer) == 0 {
            var currentPointer = interfaceAddressPointer
            while currentPointer != nil {
                defer { currentPointer = currentPointer?.pointee.ifa_next }

                guard let networkInterface = currentPointer?.pointee else { continue }
                let addressFamily = networkInterface.ifa_addr.pointee.sa_family

                if addressFamily == UInt8(AF_INET) {
                    let interfaceName = String(cString: networkInterface.ifa_name)
                    var hostNameBuffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    // Use sizeof(sockaddr_in) for IPv4 addresses
                    getnameinfo(networkInterface.ifa_addr, socklen_t(MemoryLayout<sockaddr_in>.size),
                                &hostNameBuffer, socklen_t(hostNameBuffer.count),
                                nil, socklen_t(0), NI_NUMERICHOST)

                    let ipAddressBytes = hostNameBuffer.prefix { $0 != 0 }.map { UInt8(bitPattern: $0) }
                    let ipAddress = String(decoding: ipAddressBytes, as: UTF8.self)

                    // Pick the first non-loopback address
                    if interfaceName != "lo0" {
                        localIPAddress = ipAddress
                        break
                    }
                }
            }
            freeifaddrs(interfaceAddressPointer)
        }

        return localIPAddress
    }

    /// Identify subsite by looking at the canonical url of 
    /// the root index.html of given directory
    private func identifySubsite(directory: String) -> String? {
        // Find the root index.html
        guard let indexData = FileManager.default.contents(atPath: "\(directory)/index.html") else { return nil }

        // Locate and extract the canonical url 
        let indexString = String(decoding: indexData, as: UTF8.self)
        // Tag intentionally not closed to allow space and `>`, `/>`
        let regex = #/<link href="([^"]+)" rel="canonical"/#
        guard let urlSubString = indexString.firstMatch(of: regex)?.1 else { return nil }

        // Checks if it's an URL
        guard let url = URL(string: String(urlSubString)) else { return nil }

        // If there is no subsite, we don't want to return anything        
        guard url.path != "/" else { return nil }

        return url.path
    }
}

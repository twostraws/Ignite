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

        if let ipAddress = getLocalIPAddress() {
            let localURL = "http://\(ipAddress):\(currentPort)"
            generateQRCode(for: localURL)
        }

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
                    getnameinfo(networkInterface.ifa_addr, socklen_t(networkInterface.ifa_addr.pointee.sa_len),
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

    /// Generates a QR code for the given URL and prints it to the terminal.
    private func generateQRCode(for url: String) {
        #if canImport(CoreImage)
        guard let qrCode = try? QRCode(utf8String: url) else { return }
        print("\n📱 Scan this QR code to access the site on your mobile device:\n")
        print(qrCode.smallAsciiRepresentation())
        #else
        print("\n Visit this address to access the site on your mobile device:\n")
        #endif
        print("URL: \(url)\n")
    }
}

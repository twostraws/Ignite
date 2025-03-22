//
// PortManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Network

/// A utility for managing TCP port assignments and availability.
///
/// `PortManager` provides functionality to check port availability, find open ports,
/// and maintain consistent port assignments for projects.
enum PortUtility {
    /// Checks if a specific TCP port is available for use.
    /// - Parameter port: The port number to check.
    /// - Returns: `true` if the port is available, `false` if it's in use or inaccessible.
    static func isPortAvailable(_ port: UInt16) -> Bool {
        let socket = socket(AF_INET, SOCK_STREAM, 0)
        if socket == -1 { return false }
        defer { close(socket) }
        
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(port).bigEndian
        addr.sin_addr.s_addr = in_addr_t(0x7f000001).bigEndian // 127.0.0.1
        
        let bind_result = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { addr in
                Darwin.bind(socket, addr, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        
        return bind_result == 0
    }

    /// Finds the first available TCP port starting from a specified number.
    /// - Parameter startingFrom: The port number to begin searching from. Defaults to 8000.
    /// - Returns: An available port number, or `nil` if no ports are available in range 8000-8999.
    static func findAvailablePort(startingFrom: UInt16 = 8000) -> UInt16? {
        var port = startingFrom
        while port < 9000 {
            if isPortAvailable(port) {
                return port
            }
            port += 1
        }
        return nil
    }

    /// Gets an existing port assignment for a project or assigns a new one.
    ///
    /// This method attempts to:
    /// 1. Read and validate an existing port from the project's `.ignite-port` file
    /// 2. If no valid port exists, find and assign a new available port
    /// 3. Persist the port assignment to disk
    ///
    /// - Parameter projectPath: The filesystem path to the project root.
    /// - Returns: A port number to use for the project. Falls back to 8000 if all else fails.
    static func getOrAssignPort(for projectPath: String) -> UInt16 {
        let portFile = projectPath + "/.ignite-port"
        
        // Try to read existing port
        if let existingPort = try? String(contentsOfFile: portFile, encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines),
            let port = UInt16(existingPort),
            isPortAvailable(port) {
            return port
        }
        
        // Assign new port
        if let newPort = findAvailablePort() {
            try? String(newPort).write(toFile: portFile, atomically: true, encoding: .utf8)
            return newPort
        }
        
        // Fallback to 8000 if something goes wrong
        return 8000
    }
}

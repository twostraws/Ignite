//
// ErrorReporter.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A service for reporting errors and warnings during the publishing process.
public final class ErrorReporter {
    /// Singleton instance for global access.
    @MainActor public static let shared = ErrorReporter()

    private var warnings: [String] = []
    private var errors: [String] = []

    private init() {}

    /// Add a warning message.
    /// - Parameter message: The warning message to add.
    public func addWarning(_ message: String) {
        warnings.append(message)
    }

    /// Add an error message.
    /// - Parameter message: The error message to add.
    public func addError(_ message: String) {
        errors.append(message)
    }

    /// Get all collected warnings.
    public func getWarnings() -> [String] {
        warnings
    }

    /// Get all collected errors.
    public func getErrors() -> [String] {
        errors
    }
}

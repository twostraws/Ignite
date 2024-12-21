//
// EnvironmentStore.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A class that manages the storage and updates of environment values.
///
/// Environment values are stored in a global singleton that can be temporarily modified
/// using the `update` method. For example:
///
/// ```swift
/// let result = EnvironmentStore.update(newEnvironment) {
///     // Code that needs the temporary environment
///     return someValue
/// }
/// ```
@MainActor
final class EnvironmentStore {
    /// The current environment values for the application.
    static var current = EnvironmentValues()

    /// Temporarily updates the environment values for the duration of an operation.
    /// - Parameters:
    ///   - environment: The new environment values to use
    ///   - operation: A closure that executes with the temporary environment
    /// - Returns: The value returned by the operation
    static func update<T>(_ environment: EnvironmentValues, operation: () -> T) -> T {
        let previous = current
        current = environment
        defer { current = previous }
        return operation()
    }
}

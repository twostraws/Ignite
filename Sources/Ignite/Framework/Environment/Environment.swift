//
// Environment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A property wrapper that provides access to values from the environment.
///
/// Use `Environment` to read values that are propagated through your site's view hierarchy. For example:
///
/// ```swift
/// struct ContentView: HTMLRootElement {
///     @Environment(\.themes) var themes
/// }
/// ```
@MainActor
@propertyWrapper public struct Environment<Value> {
    /// The key path to the desired environment value.
    private let keyPath: KeyPath<EnvironmentValues, Value>

    /// The current value from the environment store.
    public var wrappedValue: Value {
        PublishingContext.shared.environment[keyPath: keyPath]
    }

    /// Creates an environment property with the given key path.
    /// - Parameter keyPath: A key path to a specific value in the environment.
    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }
}

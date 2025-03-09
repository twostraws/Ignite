//
// AnimationManager.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A thread-safe manager class that handles registration and generation of CSS animations.
///
/// `AnimationManager` serves as the central coordinator for all animations in an Ignite application,
/// managing their registration, storage, and CSS generation. It ensures thread safety through
/// the `@MainActor` attribute.
@MainActor
final class AnimationManager {
    /// A type that encapsulates an animation and its trigger condition.
    private struct AnimationClassComponents: Hashable, Equatable, Sendable {
        /// The event that triggers this animation.
        var trigger: AnimationTrigger

        /// The animation to execute when triggered.
        var animation: any Animatable

        static func == (lhs: AnimationClassComponents, rhs: AnimationClassComponents) -> Bool {
            String(describing: lhs).truncatedHash == String(describing: rhs).truncatedHash
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(String(describing: self).truncatedHash)
        }
    }

    /// The shared singleton instance of the animation manager.
    static let shared = AnimationManager()

    /// Storage for registered animations, keyed by element ID and trigger type.
    ///
    /// The structure maps element IDs to a dictionary of animation triggers and their
    /// corresponding resolved animations.
    private var animations = OrderedSet<AnimationClassComponents>()

    /// Private initializer to enforce singleton pattern.
    private init() {}

    /// Registers a resolved animation for a specific element.
    /// - Parameters:
    ///   - animation: The resolved animation to register
    ///   - elementID: The unique identifier of the element to animate
    func register(_ animation: any Animatable, for trigger: AnimationTrigger) {
        animations.append(.init(trigger: trigger, animation: animation))
    }

    /// Generates and writes CSS for all registered animations to a file.
    /// - Parameter file: The URL where the CSS file should be written
    func write(to file: URL) {
        let cssBlocks = animations.map { components in
            let generator = AnimationClassGenerator(trigger: components.trigger, animation: components.animation)
            return generator.build()
        }

        do {
            let existingContent = try String(contentsOf: file, encoding: .utf8)
            let newContent = existingContent + "\n\n" + cssBlocks.joined(separator: "\n\n")
            try newContent.write(to: file, atomically: true, encoding: .utf8)
        } catch {
            PublishingContext.shared.addError(.failedToWriteFile("css/ignite-core.min.css"))
        }
    }
}

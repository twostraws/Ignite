//
//  EnvironmentEffect.swift
//  Ignite
//
//  Created by JP Toro on 10/26/24.
//

import Foundation

public extension PageElement {
    /// Applies styles to an element based on the system environment preferences.
    /// - Parameters:
    ///   - value: The environment value to respond to, such as `ColorScheme.dark` or `ColorScheme.light`.
    ///   - context: The publishing context for the current build.
    ///   - modifications: A closure that takes the element and returns a modified version with the desired styles.
    /// - Returns: A modified element that changes its appearance based on the specified environment value.
    ///
    /// Use this modifier to apply different styles based on system preferences like dark mode:
    ///
    /// ```swift
    /// struct MyPage: StaticPage {
    ///     var title = "MyPage"
    ///     func body(context: PublishingContext) -> [BlockElement] {
    ///         Text("MyText")
    ///             .environmentEffect(ColorScheme.dark, context) { text in
    ///                 text.foregroundStyle(.white)
    ///             }
    ///             .environmentEffect(ColorScheme.light, context) { text in
    ///                 text.foregroundStyle(.black)
    ///             }
    ///     }
    /// }
    /// ```
    func environmentEffect<T: Environment.MediaQueryValue>(
        _ value: T,
        _ context: PublishingContext,
        modifications: (Self) -> Self
    ) -> Self {
        let className = "env-\(value.key)-\(value.rawValue)"
        let modified = self.class(className)
        let modifiedElement = modifications(modified)
        
        let newStyles = modifiedElement.attributes.styles.filter { style in
            !modified.attributes.styles.contains { $0.name == style.name }
        }
        
        if !newStyles.isEmpty {
            let styleRule = newStyles.map { "\($0.name): \($0.value);" }.joined(separator: " ")
            let cssRule = """
            @media (\(value.query): \(value.rawValue)) {
                .\(className) { \(styleRule) }
            }
            """
            
            let cssPath = context.buildDirectory.appending(path: "css/media-queries.min.css")
            if !FileManager.default.fileExists(atPath: cssPath.path()) {
                try? FileManager.default.createDirectory(
                    at: cssPath.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
            }
            
            var existingContent = ""
            if let data = try? Data(contentsOf: cssPath),
               let content = String(data: data, encoding: .utf8)
            {
                existingContent = content + "\n"
            }
            
            try? (existingContent + cssRule).write(
                to: cssPath,
                atomically: true,
                encoding: .utf8
            )
        }
        
        return modified
    }
}

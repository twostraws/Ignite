
/// A result builder that enables declarative syntax for constructing layouts.
@MainActor
@resultBuilder
public struct LayoutBuilder {
    public static func buildBlock(_ components: any RootHTML...) -> some HTML {
        HTMLDocument {
            // If no HTMLHead is provided, add a default one
            if !components.contains(where: { $0 is Head }) {
                Head()
            }

            // Add all provided components
            for component in components {
                component
            }
        }
    }

    // Support empty layouts
    public static func buildBlock() -> some HTML {
        HTMLDocument {
            Head()
            Body()
        }
    }
}

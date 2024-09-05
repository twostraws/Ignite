/// Configuration option including a remote or local manifest file or none at all
public enum WebAppOptions {
    /// Use a local manifest file. This will copy manifest file to the
    /// generated code and add reference in the generated pages
    case localManifest
    /// Don't add manifest file reference in generated pages and don't copy any
    /// files over
    case none
}

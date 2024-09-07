/// Configuration option including a remote or local version of Bootstrap or none at all
public enum BootstrapOptions {
    /// Use a local copy of Bootstrap. This will copy Bootstrap's CSS and JavasScript to the
    /// generated code and add references in the generated pages
    case localBootstrap
    /// Use a remote copy of Bootstrap. This will add references to the Bootstrap in the
    /// generated pages and reference Bootstrap's CDN. Local copies of Boostrap
    /// will not be copied over
    case remoteBootstrap
    /// Don't add any rereferences to Bootstrap in the generated pages and don't copy any
    /// files over
    case none
}

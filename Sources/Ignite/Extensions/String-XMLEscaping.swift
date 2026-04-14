//
// String-XMLEscaping.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension String {
    /// Escapes XML special characters for use outside CDATA sections.
    ///
    /// Replaces `&`, `<`, `>`, `"`, and `'` with their corresponding
    /// XML entity references. This is necessary for text content in
    /// RSS and Atom feed elements that are not wrapped in CDATA.
    var xmlEscaped: String {
        self.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&apos;")
    }
}

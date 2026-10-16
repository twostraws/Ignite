//
// StringCatalog.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A string catalog (`.xcstrings`) read directly from its JSON source.
///
/// Plural and device variations are not supported.
struct StringCatalog: Decodable, Sendable {
    /// The translations for one key.
    struct Entry: Decodable, Sendable {
        /// The translations for this key, keyed by language identifier.
        var localizations: [String: Localization]?
    }

    /// The translation of one key into one language.
    struct Localization: Decodable, Sendable {
        /// The translated string, if this localization has one.
        var stringUnit: StringUnit?
    }

    /// A translated string.
    struct StringUnit: Decodable, Sendable {
        /// The translated text.
        var value: String
    }

    /// The language the catalog's keys are written in.
    var sourceLanguage: String

    /// The entries in this catalog, keyed by string key.
    var strings: [String: Entry]

    /// An empty catalog, used when no catalog is configured or loading fails.
    static let empty = StringCatalog(sourceLanguage: "en", strings: [:])

    init(sourceLanguage: String, strings: [String: Entry]) {
        self.sourceLanguage = sourceLanguage
        self.strings = strings
    }

    /// Reads a catalog from a `.xcstrings` file.
    /// - Parameter url: The location of the catalog.
    init(contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        self = try JSONDecoder().decode(StringCatalog.self, from: data)
    }

    /// Looks up the translation for a key.
    ///
    /// Tries the full language identifier, then its language code,
    /// then the source language, and finally returns the key itself.
    /// - Parameters:
    ///   - key: The string key to look up.
    ///   - language: The language identifier to translate into, such as `pt-BR`.
    /// - Returns: The best available translation of the key.
    func localizedString(for key: String, language: String) -> String {
        guard let localizations = strings[key]?.localizations else { return key }

        let identifier = language.replacingOccurrences(of: "_", with: "-")
        let languageCode = identifier.split(separator: "-").first.map(String.init) ?? identifier

        for candidate in [identifier, languageCode, sourceLanguage] {
            if let value = localizations[candidate]?.stringUnit?.value {
                return value
            }
        }

        return key
    }
}

/// Loads string catalogs once and shares them across a publish operation.
final class StringCatalogCache: @unchecked Sendable {
    /// Guards `catalogs`.
    private let lock = NSLock()

    /// The catalogs loaded so far, keyed by file location.
    private var catalogs = [URL: StringCatalog]()

    /// Returns the catalog at a location, loading it on first use.
    /// - Parameters:
    ///   - url: The location of the catalog.
    ///   - onFailure: Called with a message if the catalog can't be read.
    /// - Returns: The catalog, or an empty catalog if it can't be read.
    func catalog(at url: URL, onFailure: (String) -> Void) -> StringCatalog {
        lock.lock()
        defer { lock.unlock() }

        if let cached = catalogs[url] {
            return cached
        }

        let catalog: StringCatalog
        do {
            catalog = try StringCatalog(contentsOf: url)
        } catch {
            onFailure("Unable to read string catalog at \(url.path): \(error.localizedDescription)")
            catalog = .empty
        }

        catalogs[url] = catalog
        return catalog
    }
}

extension PublishingContext {
    /// Translates a string key using the site's catalog and the current page language.
    /// - Parameter key: The string key to look up.
    /// - Returns: The translation, or the key if there is none.
    func localizedString(for key: String) -> String {
        guard let url = site.localizationCatalog else { return key }

        let catalog = stringCatalogs.catalog(at: url) { addWarning($0) }
        return catalog.localizedString(for: key, language: environment.language.rawValue)
    }
}

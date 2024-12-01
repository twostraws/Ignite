//
// ResourceDecoder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct DecodeAction {
    /// The root directory for the user's website package.
    var sourceDirectory: URL

    /// Returns the contents of a file in your Resources folder, if it exists.
    /// - Parameter resource: The file to look for, e.g. "quotes.json"
    /// - Returns: A `Data` instance of the file's contents, if it can be found.
    public func data(forResource resource: String) -> Data? {
        if let url = url(forResource: resource) {
            try? Data(contentsOf: url)
        } else {
            nil
        }
    }

    /// Returns the full path to a file in your Resources folder, if it exists.
    /// - Parameter resource: The file to look for, e.g. "quotes.json"
    /// - Returns: The URL, if the file can be found.
    public func url(forResource resource: String) -> URL? {
        let fullURL = sourceDirectory.appending(path: "Resources/\(resource)")

        if FileManager.default.fileExists(atPath: fullURL.path()) {
            return fullURL
        } else {
            return nil
        }
    }

    /// Locates, loads, and decodes a JSON file in your Resources folder.
    /// - Parameters:
    ///   - resource: The file to look for, e.g. "quotes.json".
    ///   - type: The type to decode to, e.g. `[String].self`.
    ///   - dateDecodingStrategy: How to decode dates. Defaults to `.deferredToDate`.
    ///   - keyDecodingStrategy: How to decode keys. Defaults to `.useDefaultKeys`.
    /// - Returns: The decoded type, if the file exists, can be loaded, and decodes
    /// correctly, otherwise nil.
    public func callAsFunction<T: Decodable>(
        resource: String,
        as type: T.Type = T.self,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T? {
        if let url = url(forResource: resource) {
            if let data = try? Data(contentsOf: url) {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = dateDecodingStrategy
                decoder.keyDecodingStrategy = keyDecodingStrategy

                do {
                    return try decoder.decode(T.self, from: data)
                } catch let DecodingError.keyNotFound(key, context) {
                    // swiftlint:disable:next line_length
                    print("Failed to decode \(resource) due to missing key '\(key.stringValue)' – \(context.debugDescription)")
                } catch let DecodingError.typeMismatch(_, context) {
                    print("Failed to decode \(resource) due to type mismatch – \(context.debugDescription)")
                } catch let DecodingError.valueNotFound(type, context) {
                    print("Failed to decode \(resource) due to missing \(type) value – \(context.debugDescription)")
                } catch DecodingError.dataCorrupted(_) {
                    print("Failed to decode \(resource) because it appears to be invalid JSON.")
                } catch {
                    print("Failed to decode \(resource): \(error.localizedDescription)")
                }
            } else {
                print("Failed to load \(resource)")
            }
        } else {
            print("Failed to locate \(resource) in Resources folder.")
        }

        // If we're still here it means something failed, and
        // an appropriate message has already been printed. So,
        // we can safely send back `nil`, meaning "not decoded."
        return nil
    }
}

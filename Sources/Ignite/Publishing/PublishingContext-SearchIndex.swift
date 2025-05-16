//
// PublishingContext-SearchIndex.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Generates a search index for all articles in the site.
    /// The index is saved as a JSON file that can be loaded by Lunr.js on the client side.
    func generateSearchIndex() {
        let searchableDocuments = searchMetadata.map { metadatum -> [String: Any] in
            return [
                "id": metadatum.id,
                "title": metadatum.title,
                "description": metadatum.description,
                "tags": metadatum.tags?.joined(separator: ",") ?? "",
                "date": metadatum.date?.formatted(date: .long, time: .omitted) ?? ""
            ]
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: searchableDocuments, options: .prettyPrinted)
            let outputPath = buildDirectory.appending(path: "search-index.json")
            try jsonData.write(to: outputPath)
        } catch {
            addError(.failedToWriteFile("search-index.json"))
        }
    }
}

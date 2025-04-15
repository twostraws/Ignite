import Foundation

extension PublishingContext {
    /// Generates a search index for all articles in the site.
    /// The index is saved as a JSON file that can be loaded by Lunr.js on the client side.
    func generateSearchIndex() {
        let searchableDocuments = allContent.map { article -> [String: Any] in
            return [
                "id": article.path,
                "title": article.title,
                "description": article.description,
                "body": article.text,
                "tags": article.tags?.joined(separator: " ") ?? "",
                "date": article.date.description
            ]
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: searchableDocuments, options: .prettyPrinted) {

            let outputPath = buildDirectory.appending(path: "search-index.json")
            try? jsonData.write(to: outputPath)
        }
    }
} 

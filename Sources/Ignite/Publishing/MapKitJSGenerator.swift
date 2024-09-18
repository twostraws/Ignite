//
// MapKitJSGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct MapKitJSGenerator {
    var site: any Site

    func generateLoadMapScript(library: [Map.MapLibrary]) -> String {
        return """
                <script
                src="https://cdn.apple-mapkit.com/mk/5.x.x/mapkit.core.js">
                crossorigin="anonymous"
                async="async"
                data-callback="initMapKit"
                data-token="\(site.mapKitToken!)"
                data-libraries="\(library.map { $0.rawValue }.joined(separator: ","))"
                </script>
                """.replacingOccurrences(of: " ", with: "")
    }
}

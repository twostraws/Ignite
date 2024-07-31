//
// Map.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// https://developer.apple.com/documentation/mapkitjs
/// Embeds a MapKit JS map.
public struct Map: BlockElement, InlineElement, LazyLoadable {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()
    
    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic
    
    /// The external MapKit Library to load.
    private var library: MapLibrary?
    
    /// https://developer.apple.com/documentation/mapkitjs/creating_a_maps_token
    /// Generate your token to access MapKit services with proper authorization.
    private var token: String?
    
    /// Longitude as a double
    private var longitude: Double
    
    /// Latitude as a Double
    private var latitude: Double
    
    
    /// Creates map on page
    /// - Parameters:
    ///   - longitude: Longitudinal Value
    ///   - latitude: Latitudinal Value
    ///   - library: Loads External MapKit Library - Defaults Basic Map
    ///   - token: Access Token - Defaults Temporary Token
    public init(longitude: Double, latitude: Double, library: MapLibrary? = .map, token: String? = "eyJraWQiOiJSNzgzRjNIOE05IiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiIyTVA4UVdLN1I2IiwiaWF0IjoxNzIxODU1OTU0LCJleHAiOjE3MjI0OTU1OTl9.ViD505SG9QW54fv5h3iv9lQsY328OlHF-1mEPdFeNzRmqrRI137IaXlGXr2W5lR9brWG7Luej1SoEyr8beXsjw") {
        self.longitude = longitude
        self.latitude = latitude
        self.library = library
    }
    
    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        
        let loadMapScript = Script(file: "https://cdn.apple-mapkit.com/mk/5.x.x/mapkit.core.js")
            .addCustomAttribute(name: "crossorigin", value: "anonymous")
            .addCustomAttribute(name: "async", value: "async")
            .data("callback", "initMapKit")
            .data("libraries", "\(library)")
            .data("token", "\(token)")
        
        let mapScript = Script(code:
        """
            // Wait for MapKit JS to be ready to use.
                const setupMapKitJs = async() => {
                    // If MapKit JS is not yet loaded...
                    if (!window.mapkit || window.mapkit.loadedLibraries.length === 0) {
                        // ...await <script>'s data-callback (window.initMapKit).
                        await new Promise(resolve => { window.initMapKit = resolve });
                        // Clean up.
                        delete window.initMapKit;
                    }
                };
                
                const main = async() => {
                    await setupMapKitJs();
                    
                    const cupertino = new mapkit.CoordinateRegion(
                        new mapkit.Coordinate(\(longitude), \(latitude)),
                        new mapkit.CoordinateSpan(0.167647972, 0.354985255)
                                                                  );
                                                                  
                // Create a map in the element whose ID is "map-container".
                    const map = new mapkit.Map("map-container");
                    map.region = cupertino;
                };
                
                main();
        """
        )
            .addCustomAttribute(name: "type", value: "module")
        
        return Group {
            loadMapScript
            mapScript
            
            """
                <style>
                    #map-container {
                        width: 100%;
                        height: 600px;
                    }
                </style>
                <div id="map-container"></div>
            """
        }
        .id("map-container")
        .attributes(attributes)
        .render(context: context)
    }
}

extension Map {
    /// https://developer.apple.com/documentation/mapkitjs/mapkitinitoptions/4087678-libraries
    /// Pick only the interfaces you need to optimize your app load time.
    /// MapKit JS divides its interfaces into libraries that you can specify when loading the framework:
    public enum MapLibrary: String, CaseIterable {
        
        /// All services interfaces (such as Search and Geocoder) and relevant data types.
        case services = "services"
        
        /// All mapkit.Map features and relevant data types.
        case fullmap = "full-map"
        
        /// Basic mapkit.Map features without overlays, annotations, and relevant data types.
        case map = "map"
        
        /// Overlays, data types, and displays on mapkit.Map.
        case overlays = "overlays"
        
        /// Annotations, data types, and displays on mapkit.Map.
        case annotations = "annotations"
        
        /// The GeoJSON importer.
        case geojson = "geojson"
        
        /// User location display and controls on mapkit.Map.
        case userlocation = "user-location"
    }
}

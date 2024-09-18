//
// Map.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public struct Annotation {
    var color: Color
    var title: String
    var subtitle: String
    var glyphText: String
    var selected: Bool

    public init(color: Color, title: String, subtitle: String, glyphText: String, selected: Bool) {
        self.color = color
        self.title = title
        self.subtitle = subtitle
        self.glyphText = glyphText
        self.selected = selected
    }
}

/// https://developer.apple.com/documentation/mapkitjs
/// Embeds a MapKit JS map.
public struct Map: BlockElement, InlineElement, LazyLoadable {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// Longitude as a double
    private var longitude: Double

    /// Latitude as a Double
    private var latitude: Double

    /// Map Annotation
    /// Imports libraries annotation and services.
    public var annotation: Annotation?

    /// Creates embeded map on page
    /// - Parameters:
    ///   - longitude: Longitudinal Value
    ///   - latitude: Latitudinal Value
    public init(
        longitude: Double,
        latitude: Double
    ) {
        self.longitude = longitude
        self.latitude = latitude
    }

    /// Creates annotated map on page
    /// - Parameters:
    ///   - longitude: Longitudinal Value
    ///   - latitude: Latitudinal Value
    ///   - annotation: Annotation
    public init(
        longitude: Double,
        latitude: Double,
        annotation: Annotation?
    ) {
        self.longitude = longitude
        self.latitude = latitude
        self.annotation = annotation
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        if context.site.mapKitToken?.isEmpty == false {
            context.addWarning("""
        Creating a map with no token should not be possible. \
        Please file a bug report on the Ignite project.
        """)
        }

        var mapScriptCode = setupMapScript()

        mapScriptCode += generateMapScriptCode(annotation: annotation, context: context)
        let mapScript = Script(code: mapScriptCode)
            .addCustomAttribute(name: "type", value: "module")

        return renderMapContainer(context: context, mapScript: mapScript)
    }

    func setupMapScript() -> String {
        return """
    const setupMapKitJs = async() => {
        if (!window.mapkit || window.mapkit.loadedLibraries.length === 0) {
            await new Promise(resolve => { window.initMapKit = resolve });
            delete window.initMapKit;
        }
    };

    const main = async() => {
        await setupMapKitJs();
    """
    }

    func generateMapScriptCode(annotation: Annotation?, context: PublishingContext) -> String {
        var script = """
    const coordinate = new mapkit.CoordinateRegion(
        new mapkit.Coordinate(\(longitude), \(latitude)),
        new mapkit.CoordinateSpan(0.167647972, 0.354985255)
    );
    const map = new mapkit.Map("map-container");
    map.region = coordinate;
    """

        context.site.mapKitLibraries = [.map]

        if let annotation = annotation {
            context.site.mapKitLibraries! += [.annotations, .services]

            script += """
        const Annotation = new mapkit.MarkerAnnotation(coordinate);
        Annotation.color = "\(annotation.color)";
        Annotation.title = "\(annotation.title)";
        Annotation.subtitle = "\(annotation.subtitle)";
        Annotation.selected = "\(annotation.subtitle)";
        Annotation.glyphText = "\(annotation.glyphText)";
        map.showItems([Annotation]);

        let clickAnnotation = null;
        map.addEventListener("single-tap", event => {
            if (clickAnnotation) {
                map.removeAnnotation(clickAnnotation);
            }
            const point = event.pointOnPage;
            const coordinate = map.convertPointOnPageToCoordinate(point);
            clickAnnotation = new mapkit.MarkerAnnotation(coordinate, {
                title: "Loading...",
                color: "#c969e0"
            });
            map.addAnnotation(clickAnnotation);
            geocoder.reverseLookup(coordinate, (error, data) => {
                const first = (!error && data.results) ? data.results[0] : null;
                clickAnnotation.title = (first && first.name) || "";
            });
        });
        """
        }

        script += """
    };
    main();
    """
        return script
    }

    private func renderMapContainer(context: PublishingContext, mapScript: Script) -> String {
        return Group {
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

// swiftlint:disable line_length
///  Domain Restricted Token - Solely works with https://ignitesamples.hackingwithswift.com
public let exampleSiteMapKitJSToken: String = "eyJraWQiOiI0UkRRVVRIMjJOIiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiIyTVA4UVdLN1I2IiwiaWF0IjoxNzI1NTk4NDM2LCJvcmlnaW4iOiJpZ25pdGVzYW1wbGVzLmhhY2tpbmd3aXRoc3dpZnQuY29tIn0.UgaNnmSfiQsD6D23LC7-_5mEY2p_hvtM_nPOfwtV48UWl1YPX5o2YgvAJpTdjMzEQZ-IPapuIXJ7DJ4N4kdo8w"
// swiftlint:enable line_length

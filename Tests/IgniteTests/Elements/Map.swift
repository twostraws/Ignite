//
// Map.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests for the `Map` element.
final class MapTests: ElementTest {

    func test_defaultMap() {
        let element = Map(longitude: 37.3349, latitude: -122.0090)
        let output = element.render(context: publishingContext)

        let expected = """
        <div><scripttype="module">constsetupMapKitJs=async()=>{if(!window.mapkit||window.mapkit.loadedLibraries.length===0){awaitnewPromise(resolve=>{window.initMapKit=resolve});deletewindow.initMapKit;}};constmain=async()=>{awaitsetupMapKitJs();constcoordinate=newmapkit.CoordinateRegion(newmapkit.Coordinate(37.3349,-122.009),newmapkit.CoordinateSpan(0.167647972,0.354985255));constmap=newmapkit.Map("map-container");map.region=coordinate;};main();</script><style>#map-container{width:100%;height:600px;}</style><divid="map-container"></div></div>
        """

        let trimmedOutput = output.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)

        let trimmedExpected = expected.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)

        XCTAssertEqual(trimmedOutput, trimmedExpected)
    }

    func test_annotatedMap() {
        let annotation = Annotation(color: .firebrick, title: "Test Annotation", subtitle: "Annotation for Testing", glyphText: "\u{F8FF}", selected: false)
        let element = Map(longitude: 37.3349, latitude: -122.0090, annotation: annotation)
        let output = element.render(context: publishingContext)

        let expected = """
        <div><scriptcrossorigin="anonymous"async="async"data-callback="initMapKit"data-token="eyJraWQiOiIySFI4OFE2VkhBIiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiIyTVA4UVdLN1I2IiwiaWF0IjoxNzI1NTk4OTc5LCJleHAiOjE3MjYyMTA3OTl9.OUU72mIDjizsBeHmcn2zaEPgsf2RQk33qqzbn62JmyLgRv_XewByeEn1szkUz6ZGNhPREhLBhYN49Ft9P0J-sw"data-libraries="map,annotations,services"src="https://cdn.apple-mapkit.com/mk/5.x.x/mapkit.core.js"></script><scripttype="module">constsetupMapKitJs=async()=>{if(!window.mapkit||window.mapkit.loadedLibraries.length===0){awaitnewPromise(resolve=>{window.initMapKit=resolve});deletewindow.initMapKit;}};constmain=async()=>{awaitsetupMapKitJs();constcoordinate=newmapkit.CoordinateRegion(newmapkit.Coordinate(37.3349,-122.009),newmapkit.CoordinateSpan(0.167647972,0.354985255));constmap=newmapkit.Map("map-container");map.region=coordinate;constAnnotation=newmapkit.MarkerAnnotation(coordinate);Annotation.color="rgb(1783434/100%)";Annotation.title="TestAnnotation";Annotation.subtitle="AnnotationforTesting";Annotation.selected="AnnotationforTesting";Annotation.glyphText="";map.showItems([Annotation]);letclickAnnotation=null;map.addEventListener("single-tap",event=>{if(clickAnnotation){map.removeAnnotation(clickAnnotation);}constpoint=event.pointOnPage;constcoordinate=map.convertPointOnPageToCoordinate(point);clickAnnotation=newmapkit.MarkerAnnotation(coordinate,{title:"Loading...",color:"#c969e0"});map.addAnnotation(clickAnnotation);geocoder.reverseLookup(coordinate,(error,data)=>{constfirst=(!error&&data.results)?data.results[0]:null;clickAnnotation.title=(first&&first.name)||"";});});};main();</script><style>#map-container{width:100%;height:600px;}</style><divid="map-container"></div></div>
        """

        let trimmedOutput = output.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)

        let trimmedExpected = expected.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)

        XCTAssertEqual(trimmedOutput, trimmedExpected)
    }

    func test_embededMap() {
        let element = Embed(title: "My Map", url: "https://embed.apple-mapkit.com/v1/place?place=I2FEB0F2FB4D7B0EE&token=eyJraWQiOiIySFI4OFE2VkhBIiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiIyTVA4UVdLN1I2IiwiaWF0IjoxNzI1NTk4OTc5LCJleHAiOjE3MjYyMTA3OTl9.OUU72mIDjizsBeHmcn2zaEPgsf2RQk33qqzbn62JmyLgRv_XewByeEn1szkUz6ZGNhPREhLBhYN49Ft9P0J-sw")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, """
        <div><iframe src="https://embed.apple-mapkit.com/v1/place?place=I2FEB0F2FB4D7B0EE&token=eyJraWQiOiIySFI4OFE2VkhBIiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiIyTVA4UVdLN1I2IiwiaWF0IjoxNzI1NTk4OTc5LCJleHAiOjE3MjYyMTA3OTl9.OUU72mIDjizsBeHmcn2zaEPgsf2RQk33qqzbn62JmyLgRv_XewByeEn1szkUz6ZGNhPREhLBhYN49Ft9P0J-sw" title="My Map" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"></iframe></div>
        """)
    }
}

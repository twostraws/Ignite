//
// URL-DecodedPath.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

#warning("Remove this")
/*
 path(percentEncoded:)
 Returns the path component of the URL, optionally removing any percent-encoding.
 func path(percentEncoded: Bool = true) -> String
 Parameters
 percentEncoded
 A Boolean value that indicates whether the URL percent-encodes any unreserved characters. Defaults to true.
 Return Value
 The path component of the URL, optionally percent-encoding any unreserved characters.
 Discussion
 The system doesn’t allow certain characters in the URL path component, so URL percent-encodes those characters to create a valid URL. Calling this function with percentEncoded = false removes any percent-encoding and returns the unencoded path.
 If the URL’s path component is empty, this method returns an empty string.
 Open in Developer Documentation
 
 */

/// Tests for the `URL-DecodedPath` extension.
@Suite("URL-DecodedPath Tests")
struct Test {

    @Test("returns empty String for empty path", arguments: [
        "https://ignitesamples.hackingwithswift.com",
        "https://github.com"
    ]) func test_empty_path(_ string: String) async throws {
        let sut = URL(string: string)!
        
        #expect(sut.decodedPath.isEmpty)
    }

}

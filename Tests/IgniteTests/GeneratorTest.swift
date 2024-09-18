//
// GeneratorTest.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

 import XCTest
 @testable import Ignite

 /// A base class that sets up an example site for testing purposes
 class GeneratorTest: XCTestCase {
     /// A Test Site with sample values
     let testSite = TestSite()

     /// Converts a JSON string into a dictionary.
     /// - Parameter jsonString: The JSON string to be converted.
     /// - Throws: An error if the JSON string cannot be converted to a dictionary.
     /// - Returns: A dictionary representation of the JSON string.
     func jsonStringToDictionary(_ jsonString: String) throws -> [String: Any] {
         let data = jsonString.data(using: .utf8)!
         return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
     }

     /// Compares two dictionaries for equality.
     /// - Parameters:
     ///   - lhs: The first dictionary to compare.
     ///   - rhs: The second dictionary to compare.
     /// - Returns: A Boolean value indicating whether the two dictionaries are equal.
     func dictionariesAreEqual(_ lhs: [String: Any], _ rhs: [String: Any]) -> Bool {
         return NSDictionary(dictionary: lhs).isEqual(to: rhs)
     }
 }

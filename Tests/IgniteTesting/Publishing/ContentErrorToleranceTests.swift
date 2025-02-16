//
// ContentErrorTolerance.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

/// Tests for a `ContentErrorTolerance` type
/// being proposed but not yet integrated.
@Suite("ContentErrorToleranceTests")
actor ContentErrorToleranceTests {

  /// Evaluate each `CETCase` defined in `CETCases`.
  @Test("tolerateErrors", arguments: CETCases.cases)
  func tolerateErrors(test: CETCase) async throws {
    #expect(test.isOk, "\(test)")
  }

  // MARK: draft implementation under test
  /// Whether to tolerate a content error.
  public enum ContentErrorTolerance: CustomStringConvertible {
    /// No errors are tolerated
    case NONE

    /// Permit when name has the specified suffix (case-sensitive)
    case filename(endsWith: String)

    /// Permit when the deploy path has the specified prefix (case-sensitive)
    case deployPath(startsWith: String)

    /// Permit when the message contains some String
    case message(contains: String)

    /// Permit up to (and including) a certain number
    case upTo(max: Int)

    /// Permit when any of these are matched
    indirect case anyOf([ContentErrorTolerance])

    /// Permit any except for these (i.e., fail if any match)
    indirect case anyExcept([ContentErrorTolerance])

    public func tolerate(
      count: Int,
      url: URL,
      deployPath: String,
      error: any Error
    ) -> Bool {
      switch self {
      case .NONE: false
      case .filename(let suffix):
        url.lastPathComponent.hasSuffix(suffix)
      case .deployPath(let prefix):
        deployPath.hasPrefix(prefix)
      case .message(let message):
        Self.extractMessage(error).contains(message)
      case .upTo(let max):
        count <= max
      case .anyExcept(let children), .anyOf(let children):
        isExcept
          == (nil
            == children.first {
              $0.tolerate(
                count: count,
                url: url,
                deployPath: deployPath,
                error: error
              )
            })
      }
    }

    public var description: String {
      switch self {
      case .NONE: "NONE"
      case .filename(let suffix): "name: *\(suffix)"
      case .deployPath(let prefix): "path: \(prefix)*"
      case .message(let contains): "message: *\(contains)*"
      case .upTo(let max): "up to \(max)"
      case .anyOf(let kids), .anyExcept(let kids):
        "\(isExcept ? "anyExcept" : "anyOf")\(kids)"
      }
    }

    private var isExcept: Bool {
      if case .anyExcept = self { return true }
      return false
    }

    static func extractMessage(_ error: any Error) -> String {
        "\(error)" // localizedDescription?
    }
  }

  // MARK: Test case declarations
  typealias CET = ContentErrorTolerance

  /// Declare and run test
  struct CETCase: CustomStringConvertible {
    let index: Int
    let tolerate: ContentErrorTolerance
    let call: CETCall
    let expected, actual: Bool
    init(_ index: Int, _ call: CETCall, _ tolerate: CET, _ exp: Bool) {
      self.index = index
      self.expected = exp
      self.tolerate = tolerate
      self.call = call
      self.actual = call.call(tolerate)  // <----- test, get actual result
    }
    var isOk: Bool { expected == actual }
    var description: String {
      "[\(index)] \(isOk ? "PASS" : "FAIL") \(tolerate) \(call.line)"
    }
  }

  /// Parameters for a call to `ContentErrorTolerance/tolerate(...)` with factories
  struct CETCall {
    let count: Int
    let url: URL
    let deployPath: String
    let error: Error
    init(_ count: Int, _ error: Error, _ url: URL, _ path: String) {
      self.count = count
      self.url = url
      self.deployPath = path
      self.error = error
    }

    var line: String {
      let errorStr = ContentErrorTolerance.extractMessage(error)
      return "\(count) \(deployPath) \(url.lastPathComponent) \(errorStr)"
    }

    /// Call `ContentErrorTolerance/tolerate(...)` and return the result
    /// - Parameter tolerate: ContentErrorTolerance under test
    /// - Returns: Bool result of the call
    func call(_ tolerate: ContentErrorTolerance) -> Bool {
      tolerate.tolerate(
        count: count,
        url: url,
        deployPath: deployPath,
        error: error
      )
    }

    /// Make a tolerant ``CETCase``
    func pass(_ i: Int, _ tolerate: ContentErrorTolerance) -> CETCase {
      .init(i, self, tolerate, true)
    }

    /// Make an intolerant ``CETCase``
    func fail(_ i: Int, _ tolerate: ContentErrorTolerance) -> CETCase {
      .init(i, self, tolerate, false)
    }
  }

    /// ``CETCase`` suite
    enum CETCases {
        static let cases = makeCases()

        private static func makeCases() -> [CETCase] {
          var last = 0
          func i() -> Int {
            last += 1
            return last
          }
          return [
            call_parse_1_good_abcMd.pass(i(), ok_max_2),
            call_parse_1_good_abcMd.pass(i(), ok_name_cMd),
            call_parse_1_good_abcMd.pass(i(), ok_path_good),
            call_parse_1_good_abcMd.pass(i(), ok_mssg_parse),
            call_parse_1_good_abcMd.pass(i(), ok_anyOf_2_cMd),
            call_parse_1_good_abcMd.pass(i(), ok_except_MD_bad),

            call_parse_1_good_abcMd.fail(i(), .NONE),
            call_parse_1_good_abcMd.fail(i(), ok_max_0),
            call_parse_1_good_abcMd.fail(i(), ok_name_MD),
            call_parse_1_good_abcMd.fail(i(), ok_path_bad),
            call_parse_1_good_abcMd.fail(i(), ok_mssg_sour),

            call_resource_3_bad_defMD.fail(i(), ok_anyOf_2_cMd),
            call_resource_3_bad_defMD.fail(i(), ok_except_MD_bad)
          ]
        }

        // ContentErrorTolerance specs
        // swiftlint:disable identifier_name
        static let ok_max_2 = CET.upTo(max: 2)
        static let ok_max_0 = CET.upTo(max: 0)
        static let ok_name_cMd = CET.filename(endsWith: "c.md")
        static let ok_name_MD = CET.filename(endsWith: "MD")
        static let ok_path_good = CET.deployPath(startsWith: "good")
        static let ok_path_bad = CET.deployPath(startsWith: "bad")
        static let ok_mssg_sour = CET.message(contains: "sour") // Err.resource
        static let ok_mssg_parse = CET.message(contains: "parse") // Err.parse

        // composites anyOf, anyExcept
        static let ok_anyOf_2_cMd = CET.anyOf([ok_max_2, ok_name_cMd])
        static let ok_except_MD_bad = CET.anyExcept([ok_name_MD, ok_path_bad])
        static let ok_anyOf_empty = CET.anyOf([])
        static let ok_except_empty = CET.anyExcept([])

        // CETCall names: call_{error}_{count}_{path}_{url/name}
        static let call_parse_1_good_abcMd
            = CETCall(1, Err.parse, url("abc.md"), "good/abc.md")
        static let call_resource_3_bad_defMD
            = CETCall(3, Err.resource, url("def.MD"), "bad/def.MD")
        // swiftlint:enable identifier_name

        static func url(_ last: String) -> URL {
          URL(filePath: last)
        }
    }
    enum Err: Error {
      case parse, resource
    }
}

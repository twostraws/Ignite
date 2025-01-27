//
//  Date-RFC822.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Date-RFC822` extension.
@Suite("Date-RFC822 Tests")
@MainActor
struct DateRFC822Tests {

    struct Instance {
        let input: Date
        let expected: String
    }
    
    @Test("Test Against Known Output", arguments: [
        Instance(input: Date(timeIntervalSince1970: 25078421870), expected: "Mon, 14 Sep 2764 08:17:50 -0400"),
        Instance(input: Date(timeIntervalSince1970: -59582421721), expected: "Thu, 29 Nov 0081 10:21:57 -045602"),
        Instance(input: Date(timeIntervalSince1970: -33611495209), expected: "Sat, 17 Nov 0904 20:37:09 -045602"),
        Instance(input: Date(timeIntervalSince1970: -31086908182), expected: "Mon, 17 Nov 0984 14:47:36 -045602"),
        Instance(input: Date(timeIntervalSince1970: 40677960908), expected: "Sun, 12 Jan 3259 12:35:08 -0500"),
        Instance(input: Date(timeIntervalSince1970: 3147646929), expected: "Sat, 28 Sep 2069 22:22:09 -0400"),
        Instance(input: Date(timeIntervalSince1970: -32571932192), expected: "Fri, 27 Oct 0937 20:07:26 -045602"),
        Instance(input: Date(timeIntervalSince1970: -3725612248), expected: "Wed, 10 Dec 1851 06:46:30 -045602"),
        Instance(input: Date(timeIntervalSince1970: -38580260670), expected: "Tue, 06 Jun 0747 23:59:28 -045602"),
        Instance(input: Date(timeIntervalSince1970: 10279542621), expected: "Mon, 30 Sep 2295 00:30:21 -0400"),
    ])
    func outputs_expected_result(instance: Instance) async throws {
        #expect(instance.input.asRFC822 == instance.expected)
    }
}

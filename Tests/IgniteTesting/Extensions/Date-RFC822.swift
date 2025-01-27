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
        Instance(input: Date(timeIntervalSince1970: 60228332501.13208), expected: "Wed, 24 Jul 3878 04:21:41 +0000"),
        Instance(input: Date(timeIntervalSince1970: 27871740518.22975), expected: "Fri, 21 Mar 2853 14:08:38 +0000"),
        Instance(input: Date(timeIntervalSince1970: -3284356034.069809), expected: "Sun, 03 Dec 1865 14:52:45 +0000"),
        Instance(input: Date(timeIntervalSince1970: 17552683531.75113), expected: "Sat, 23 Mar 2526 01:25:31 +0000"),
        Instance(input: Date(timeIntervalSince1970: 52184037958.68115), expected: "Thu, 24 Aug 3623 22:05:58 +0000"),
        Instance(input: Date(timeIntervalSince1970: -46964633818.02554), expected: "Tue, 29 Sep 0481 20:23:01 +0000"),
        Instance(input: Date(timeIntervalSince1970: 9676773717.779556), expected: "Wed, 23 Aug 2276 16:41:57 +0000"),
        Instance(input: Date(timeIntervalSince1970: -46716978084.27513), expected: "Sat, 05 Aug 0489 05:38:35 +0000"),
        Instance(input: Date(timeIntervalSince1970: 60228133082.71135), expected: "Sun, 21 Jul 3878 20:58:02 +0000"),
        Instance(input: Date(timeIntervalSince1970: -37373736994.632614), expected: "Tue, 30 Aug 0785 14:23:25 +0000")
    ])
    func outputs_expected_result(instance: Instance) async throws {
        #expect(instance.input.asRFC822 == instance.expected)
    }
}

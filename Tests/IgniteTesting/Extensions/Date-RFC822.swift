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
///
/// NOTE: These tests only test against dates in the Unix Epoch
/// (since January 1, 1970, see https://en.wikipedia.org/wiki/Unix_time)
/// Testing time zone output against historical times (times before standardized time zones)
/// is tricky and beyond the scope of what this project needs.
@Suite("Date-RFC822 Tests")
@MainActor
struct DateRFC822Tests {

    struct Instance {
        let input: Date
        let expected: String
    }

    @Test("Known Output for Greenwich Mean Time", arguments: [
        Instance(input: Date(timeIntervalSince1970: 20012346618.957466), expected: "Fri, 02 Mar 2604 09:10:18 +0000"),
        Instance(input: Date(timeIntervalSince1970: 56076958399.89086), expected: "Tue, 03 Jan 3747 20:53:19 +0000"),
        Instance(input: Date(timeIntervalSince1970: 43889947931.30432), expected: "Sat, 25 Oct 3360 12:12:11 +0000"),
        Instance(input: Date(timeIntervalSince1970: 60401587537.13003), expected: "Sat, 19 Jan 3884 10:45:37 +0000"),
        Instance(input: Date(timeIntervalSince1970: 2887257381.52073), expected: "Wed, 29 Jun 2061 07:56:21 +0000"),
        Instance(input: Date(timeIntervalSince1970: 15764928045.389473), expected: "Sat, 27 Jul 2469 10:40:45 +0000"),
        Instance(input: Date(timeIntervalSince1970: 30573435574.337566), expected: "Sat, 01 Nov 2938 04:59:34 +0000"),
        Instance(input: Date(timeIntervalSince1970: 2818825684.6154914), expected: "Tue, 29 Apr 2059 07:08:04 +0000"),
        Instance(input: Date(timeIntervalSince1970: 9199677333.36627), expected: "Thu, 11 Jul 2261 17:55:33 +0000"),
        Instance(input: Date(timeIntervalSince1970: 53706378711.11124), expected: "Fri, 20 Nov 3671 14:31:51 +0000")
    ])
    func outputs_expected_result_for_greenwich_mean_time(instance: Instance) async throws {
        // GMT
        let timezone = TimeZone(abbreviation: "GMT")
        #expect(instance.input.asRFC822(timeZone: timezone) == instance.expected)
    }

    @Test("Known Output for New York Time", arguments: [
        Instance(input: Date(timeIntervalSince1970: 20012346618.957466), expected: "Fri, 02 Mar 2604 04:10:18 -0500"),
        Instance(input: Date(timeIntervalSince1970: 56076958399.89086), expected: "Tue, 03 Jan 3747 15:53:19 -0500"),
        Instance(input: Date(timeIntervalSince1970: 43889947931.30432), expected: "Sat, 25 Oct 3360 08:12:11 -0400"),
        Instance(input: Date(timeIntervalSince1970: 60401587537.13003), expected: "Sat, 19 Jan 3884 05:45:37 -0500"),
        Instance(input: Date(timeIntervalSince1970: 2887257381.52073), expected: "Wed, 29 Jun 2061 03:56:21 -0400"),
        Instance(input: Date(timeIntervalSince1970: 15764928045.389473), expected: "Sat, 27 Jul 2469 06:40:45 -0400"),
        Instance(input: Date(timeIntervalSince1970: 30573435574.337566), expected: "Sat, 01 Nov 2938 00:59:34 -0400"),
        Instance(input: Date(timeIntervalSince1970: 2818825684.6154914), expected: "Tue, 29 Apr 2059 03:08:04 -0400"),
        Instance(input: Date(timeIntervalSince1970: 9199677333.36627), expected: "Thu, 11 Jul 2261 13:55:33 -0400"),
        Instance(input: Date(timeIntervalSince1970: 53706378711.11124), expected: "Fri, 20 Nov 3671 09:31:51 -0500")
    ])
    func outputs_expected_result_for_new_york_time(instance: Instance) async throws {
        // EDT - America/New_York
        // western hemisphere
        // 5 hours behind GMT
        let timezone = TimeZone(abbreviation: "EDT")
        #expect(instance.input.asRFC822(timeZone: timezone) == instance.expected)
    }

    @Test("Known Output for America/St Johns Time", arguments: [
        Instance(input: Date(timeIntervalSince1970: 20012346618.957466), expected: "Fri, 02 Mar 2604 05:40:18 -0330"),
        Instance(input: Date(timeIntervalSince1970: 56076958399.89086), expected: "Tue, 03 Jan 3747 17:23:19 -0330"),
        Instance(input: Date(timeIntervalSince1970: 43889947931.30432), expected: "Sat, 25 Oct 3360 09:42:11 -0230"),
        Instance(input: Date(timeIntervalSince1970: 60401587537.13003), expected: "Sat, 19 Jan 3884 07:15:37 -0330"),
        Instance(input: Date(timeIntervalSince1970: 2887257381.52073), expected: "Wed, 29 Jun 2061 05:26:21 -0230"),
        Instance(input: Date(timeIntervalSince1970: 15764928045.389473), expected: "Sat, 27 Jul 2469 08:10:45 -0230"),
        Instance(input: Date(timeIntervalSince1970: 30573435574.337566), expected: "Sat, 01 Nov 2938 02:29:34 -0230"),
        Instance(input: Date(timeIntervalSince1970: 2818825684.6154914), expected: "Tue, 29 Apr 2059 04:38:04 -0230"),
        Instance(input: Date(timeIntervalSince1970: 9199677333.36627), expected: "Thu, 11 Jul 2261 15:25:33 -0230"),
        Instance(input: Date(timeIntervalSince1970: 53706378711.11124), expected: "Fri, 20 Nov 3671 11:01:51 -0330")
    ])
    func outputs_expected_result_for_st_johns_time(instance: Instance) async throws {

        // NDT - America/St_Johns
        // western hemisphere
        // 3.5 hours behind GMT
        let timezone = TimeZone(abbreviation: "NDT")
        #expect(instance.input.asRFC822(timeZone: timezone) == instance.expected)
    }

    @Test("Known Output for Asia/Jakarta Time", arguments: [
        Instance(input: Date(timeIntervalSince1970: 20012346618.957466), expected: "Fri, 02 Mar 2604 16:10:18 +0700"),
        Instance(input: Date(timeIntervalSince1970: 56076958399.89086), expected: "Wed, 04 Jan 3747 03:53:19 +0700"),
        Instance(input: Date(timeIntervalSince1970: 43889947931.30432), expected: "Sat, 25 Oct 3360 19:12:11 +0700"),
        Instance(input: Date(timeIntervalSince1970: 60401587537.13003), expected: "Sat, 19 Jan 3884 17:45:37 +0700"),
        Instance(input: Date(timeIntervalSince1970: 2887257381.52073), expected: "Wed, 29 Jun 2061 14:56:21 +0700"),
        Instance(input: Date(timeIntervalSince1970: 15764928045.389473), expected: "Sat, 27 Jul 2469 17:40:45 +0700"),
        Instance(input: Date(timeIntervalSince1970: 30573435574.337566), expected: "Sat, 01 Nov 2938 11:59:34 +0700"),
        Instance(input: Date(timeIntervalSince1970: 2818825684.6154914), expected: "Tue, 29 Apr 2059 14:08:04 +0700"),
        Instance(input: Date(timeIntervalSince1970: 9199677333.36627), expected: "Fri, 12 Jul 2261 00:55:33 +0700"),
        Instance(input: Date(timeIntervalSince1970: 53706378711.11124), expected: "Fri, 20 Nov 3671 21:31:51 +0700")
    ])
    func outputs_expected_result_for_jakarta_time(instance: Instance) async throws {

        // WIT - Asia/Jakarta
        // eastern hemisphere
        // 7 hours before GMT
        let timezone = TimeZone(abbreviation: "WIT")
        #expect(instance.input.asRFC822(timeZone: timezone) == instance.expected)
    }

    @Test("Known Output for Asia/Kolkata Time", arguments: [
        Instance(input: Date(timeIntervalSince1970: 20012346618.957466), expected: "Fri, 02 Mar 2604 14:40:18 +0530"),
        Instance(input: Date(timeIntervalSince1970: 56076958399.89086), expected: "Wed, 04 Jan 3747 02:23:19 +0530"),
        Instance(input: Date(timeIntervalSince1970: 43889947931.30432), expected: "Sat, 25 Oct 3360 17:42:11 +0530"),
        Instance(input: Date(timeIntervalSince1970: 60401587537.13003), expected: "Sat, 19 Jan 3884 16:15:37 +0530"),
        Instance(input: Date(timeIntervalSince1970: 2887257381.52073), expected: "Wed, 29 Jun 2061 13:26:21 +0530"),
        Instance(input: Date(timeIntervalSince1970: 15764928045.389473), expected: "Sat, 27 Jul 2469 16:10:45 +0530"),
        Instance(input: Date(timeIntervalSince1970: 30573435574.337566), expected: "Sat, 01 Nov 2938 10:29:34 +0530"),
        Instance(input: Date(timeIntervalSince1970: 2818825684.6154914), expected: "Tue, 29 Apr 2059 12:38:04 +0530"),
        Instance(input: Date(timeIntervalSince1970: 9199677333.36627), expected: "Thu, 11 Jul 2261 23:25:33 +0530"),
        Instance(input: Date(timeIntervalSince1970: 53706378711.11124), expected: "Fri, 20 Nov 3671 20:01:51 +0530")
    ])
    func outputs_expected_result_for_kolkata_time(instance: Instance) async throws {

        // IST - Asia/Kolkata
        // eastern hemisphere
        // 5.5 hours before GMT
        let timezone = TimeZone(abbreviation: "IST")
        #expect(instance.input.asRFC822(timeZone: timezone) == instance.expected)
    }

}

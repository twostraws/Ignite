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

    @Test("Print Out supported timezones with abbreviations")
    func reportTimeZoneInfo() async throws {
        for (abbreviation, identifier) in TimeZone.abbreviationDictionary {
            guard let timezone = TimeZone(identifier: identifier) else { continue }
            
            print("\(abbreviation)\t\(Double(timezone.secondsFromGMT())/3600)\t\(identifier)")
        }
        /* Output:
         PET    -5.0    America/Lima
         EST    -5.0    America/New_York
         PDT    -8.0    America/Los_Angeles
         KST    9.0    Asia/Seoul
         MST    -7.0    America/Phoenix
         WET    0.0    Europe/Lisbon
         BDT    6.0    Asia/Dhaka
         EEST    2.0    Europe/Athens
         SGT    8.0    Asia/Singapore
         CLST    -3.0    America/Santiago
         BRST    -3.0    America/Sao_Paulo
         CDT    -6.0    America/Chicago
         CEST    1.0    Europe/Paris
         EAT    3.0    Africa/Addis_Ababa
         CST    -6.0    America/Chicago
         UTC    0.0    UTC
         WEST    0.0    Europe/Lisbon
         PHT    8.0    Asia/Manila
         GMT    0.0    GMT
         MSK    3.0    Europe/Moscow
         NDT    -3.5    America/St_Johns
         IRST    3.5    Asia/Tehran
         AKST    -9.0    America/Juneau
         ICT    7.0    Asia/Bangkok
         AKDT    -9.0    America/Juneau
         EET    2.0    Europe/Athens
         CLT    -3.0    America/Santiago
         PST    -8.0    America/Los_Angeles
         TRT    3.0    Europe/Istanbul
         BRT    -3.0    America/Sao_Paulo
         COT    -5.0    America/Bogota
         NZST    13.0    Pacific/Auckland
         CET    1.0    Europe/Paris
         NST    -3.5    America/St_Johns
         WAT    1.0    Africa/Lagos
         NZDT    13.0    Pacific/Auckland
         PKT    5.0    Asia/Karachi
         CAT    2.0    Africa/Harare
         ADT    -4.0    America/Halifax
         HST    -10.0    Pacific/Honolulu
         AST    -4.0    America/Halifax
         GST    4.0    Asia/Dubai
         MSD    3.0    Europe/Moscow
         EDT    -5.0    America/New_York
         JST    9.0    Asia/Tokyo
         HKT    8.0    Asia/Hong_Kong
         MDT    -7.0    America/Denver
         BST    0.0    Europe/London
         WIT    7.0    Asia/Jakarta
         ART    -3.0    America/Argentina/Buenos_Aires
         IST    5.5    Asia/Kolkata
         */
    }
    @Test("Generate Instances in other time zones")
    func generate_EDT_rfc822() async throws {
        let times: [TimeInterval] = [
            60228332501.13208,
            27871740518.22975,
            -3284356034.069809,
            17552683531.75113,
            52184037958.68115,
            -46964633818.02554,
            9676773717.779556,
            -46716978084.27513,
            60228133082.71135,
            -37373736994.632614
        ]
                
        let timezones: [TimeZone] = [
            TimeZone(abbreviation: "EDT"), // north america, daylight savings
            TimeZone(abbreviation: "NDT"), // americas, off by 30 min from most timezones
            TimeZone(abbreviation: "WIT"), // asica, ahead of GMT
            TimeZone(abbreviation: "IST") // asia, ahead of GMT, off by 30 min from most timezones
        ].compactMap(\.self)
        
        for timezone in timezones {
            print(timezone.abbreviation())
            for time in times {
                let date = Date(timeIntervalSince1970: time)
                print("Instance(input: Date(timeIntervalSince1970: \(time), expected: \"\(date.asRFC822(timeZone: timezone))\"),")
            }
        }
        /* Output:
         Optional("EST")
         Instance(input: Date(timeIntervalSince1970: 60228332501.13208, expected: "Wed, 24 Jul 3878 00:21:41 -0400"),
         Instance(input: Date(timeIntervalSince1970: 27871740518.22975, expected: "Fri, 21 Mar 2853 10:08:38 -0400"),
         Instance(input: Date(timeIntervalSince1970: -3284356034.069809, expected: "Sun, 03 Dec 1865 09:56:43 -045602"),
         Instance(input: Date(timeIntervalSince1970: 17552683531.75113, expected: "Fri, 22 Mar 2526 21:25:31 -0400"),
         Instance(input: Date(timeIntervalSince1970: 52184037958.68115, expected: "Thu, 24 Aug 3623 18:05:58 -0400"),
         Instance(input: Date(timeIntervalSince1970: -46964633818.02554, expected: "Tue, 29 Sep 0481 15:26:59 -045602"),
         Instance(input: Date(timeIntervalSince1970: 9676773717.779556, expected: "Wed, 23 Aug 2276 12:41:57 -0400"),
         Instance(input: Date(timeIntervalSince1970: -46716978084.27513, expected: "Sat, 05 Aug 0489 00:42:33 -045602"),
         Instance(input: Date(timeIntervalSince1970: 60228133082.71135, expected: "Sun, 21 Jul 3878 16:58:02 -0400"),
         Instance(input: Date(timeIntervalSince1970: -37373736994.632614, expected: "Tue, 30 Aug 0785 09:27:23 -045602"),
         
         NDT
         Optional("GMT-3:30")
         Instance(input: Date(timeIntervalSince1970: 60228332501.13208, expected: "Wed, 24 Jul 3878 01:51:41 -0230"),
         Instance(input: Date(timeIntervalSince1970: 27871740518.22975, expected: "Fri, 21 Mar 2853 11:38:38 -0230"),
         Instance(input: Date(timeIntervalSince1970: -3284356034.069809, expected: "Sun, 03 Dec 1865 11:21:53 -033052"),
         Instance(input: Date(timeIntervalSince1970: 17552683531.75113, expected: "Fri, 22 Mar 2526 22:55:31 -0230"),
         Instance(input: Date(timeIntervalSince1970: 52184037958.68115, expected: "Thu, 24 Aug 3623 19:35:58 -0230"),
         Instance(input: Date(timeIntervalSince1970: -46964633818.02554, expected: "Tue, 29 Sep 0481 16:52:09 -033052"),
         Instance(input: Date(timeIntervalSince1970: 9676773717.779556, expected: "Wed, 23 Aug 2276 14:11:57 -0230"),
         Instance(input: Date(timeIntervalSince1970: -46716978084.27513, expected: "Sat, 05 Aug 0489 02:07:43 -033052"),
         Instance(input: Date(timeIntervalSince1970: 60228133082.71135, expected: "Sun, 21 Jul 3878 18:28:02 -0230"),
         Instance(input: Date(timeIntervalSince1970: -37373736994.632614, expected: "Tue, 30 Aug 0785 10:52:33 -033052"),
         
         WIT
         Optional("GMT+7")
         Instance(input: Date(timeIntervalSince1970: 60228332501.13208, expected: "Wed, 24 Jul 3878 11:21:41 +0700"),
         Instance(input: Date(timeIntervalSince1970: 27871740518.22975, expected: "Fri, 21 Mar 2853 21:08:38 +0700"),
         Instance(input: Date(timeIntervalSince1970: -3284356034.069809, expected: "Sun, 03 Dec 1865 21:59:57 +070712"),
         Instance(input: Date(timeIntervalSince1970: 17552683531.75113, expected: "Sat, 23 Mar 2526 08:25:31 +0700"),
         Instance(input: Date(timeIntervalSince1970: 52184037958.68115, expected: "Fri, 25 Aug 3623 05:05:58 +0700"),
         Instance(input: Date(timeIntervalSince1970: -46964633818.02554, expected: "Wed, 30 Sep 0481 03:30:13 +070712"),
         Instance(input: Date(timeIntervalSince1970: 9676773717.779556, expected: "Wed, 23 Aug 2276 23:41:57 +0700"),
         Instance(input: Date(timeIntervalSince1970: -46716978084.27513, expected: "Sat, 05 Aug 0489 12:45:47 +070712"),
         Instance(input: Date(timeIntervalSince1970: 60228133082.71135, expected: "Mon, 22 Jul 3878 03:58:02 +0700"),
         Instance(input: Date(timeIntervalSince1970: -37373736994.632614, expected: "Tue, 30 Aug 0785 21:30:37 +070712"),
         
         IST
         Optional("GMT+5:30")
         Instance(input: Date(timeIntervalSince1970: 60228332501.13208, expected: "Wed, 24 Jul 3878 09:51:41 +0530"),
         Instance(input: Date(timeIntervalSince1970: 27871740518.22975, expected: "Fri, 21 Mar 2853 19:38:38 +0530"),
         Instance(input: Date(timeIntervalSince1970: -3284356034.069809, expected: "Sun, 03 Dec 1865 20:46:05 +055320"),
         Instance(input: Date(timeIntervalSince1970: 17552683531.75113, expected: "Sat, 23 Mar 2526 06:55:31 +0530"),
         Instance(input: Date(timeIntervalSince1970: 52184037958.68115, expected: "Fri, 25 Aug 3623 03:35:58 +0530"),
         Instance(input: Date(timeIntervalSince1970: -46964633818.02554, expected: "Wed, 30 Sep 0481 02:16:29 +055328"),
         Instance(input: Date(timeIntervalSince1970: 9676773717.779556, expected: "Wed, 23 Aug 2276 22:11:57 +0530"),
         Instance(input: Date(timeIntervalSince1970: -46716978084.27513, expected: "Sat, 05 Aug 0489 11:32:03 +055328"),
         Instance(input: Date(timeIntervalSince1970: 60228133082.71135, expected: "Mon, 22 Jul 3878 02:28:02 +0530"),
         Instance(input: Date(timeIntervalSince1970: -37373736994.632614, expected: "Tue, 30 Aug 0785 20:16:53 +055328"),

         
         */
    }


    @Test("Test Against Known Output for Default Time Zone", arguments: [
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
        #expect(instance.input.asRFC822() == instance.expected)
    }
}

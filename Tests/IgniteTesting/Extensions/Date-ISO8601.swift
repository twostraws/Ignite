//
//  Date-ISO8601.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Date-ISO8601` extension.
@Suite("Date-ISO8601 Tests")
@MainActor
struct DateISO8601Tests {

    let exampleISO8601Strings = """
0563-05-30T21:58:41Z
3907-04-07T17:49:01Z
3230-12-06T21:46:10Z
0952-12-09T02:07:18Z
2243-03-15T02:42:27Z
3029-10-03T08:37:28Z
3946-11-27T12:55:21Z
2329-04-15T09:06:57Z
0971-06-23T22:04:19Z
2258-08-20T20:12:15Z
2940-10-03T00:16:20Z
1501-02-23T22:20:02Z
2539-03-18T01:21:46Z
1520-06-08T17:13:36Z
1083-10-05T03:17:05Z
2817-01-24T20:01:56Z
3629-10-19T13:53:42Z
1711-10-03T00:14:05Z
3597-07-23T20:39:40Z
0694-10-18T00:03:00Z
3128-11-25T08:25:25Z
2571-06-26T04:38:46Z
3617-12-06T04:36:05Z
3755-12-06T10:40:32Z
0001-01-24T00:54:26Z
2300-10-21T14:36:52Z
3595-04-14T07:59:00Z
0993-02-05T03:35:52Z
2195-04-11T16:58:27Z
1722-06-15T06:43:08Z
2141-02-25T14:17:49Z
0934-11-27T00:19:02Z
1966-06-03T02:08:19Z
3309-03-03T22:02:18Z
2132-03-14T08:51:10Z
3852-04-23T17:12:00Z
2517-07-22T12:47:42Z
1568-01-11T16:53:44Z
1981-11-04T07:22:04Z
2333-09-15T21:45:32Z
0058-01-14T13:23:48Z
1488-06-24T19:44:27Z
0361-05-09T05:18:55Z
0646-12-19T04:53:22Z
2254-09-04T09:27:37Z
2688-10-11T07:12:57Z
2103-06-18T10:49:18Z
0896-08-07T05:29:46Z
0850-10-31T03:23:48Z
1761-09-19T00:25:18Z
2335-02-01T00:23:47Z
0133-11-13T03:09:36Z
3984-10-25T07:41:29Z
1026-12-03T07:35:50Z
2839-08-14T04:03:23Z
1504-07-07T11:03:56Z
3024-08-19T09:09:45Z
0001-07-09T07:18:18Z
1762-10-09T08:34:29Z
3338-12-18T02:29:28Z
3980-06-03T04:21:50Z
1210-04-16T02:36:05Z
0290-08-11T13:06:13Z
1333-12-24T09:13:29Z
0031-10-11T08:36:41Z
0789-10-24T03:38:28Z
3628-10-02T11:04:47Z
1650-07-20T06:31:05Z
2068-03-12T08:06:32Z
1484-01-17T22:36:36Z
3164-04-15T00:42:39Z
1936-08-19T22:42:49Z
3037-07-25T16:49:35Z
0599-05-02T00:22:26Z
0258-07-07T15:57:36Z
0606-05-06T15:29:19Z
0473-12-07T06:51:41Z
2709-02-07T23:41:47Z
0062-08-21T05:47:13Z
2231-04-15T08:12:32Z
1608-09-21T01:38:56Z
3475-11-25T23:03:59Z
0744-05-05T17:21:51Z
3414-09-23T06:39:37Z
0789-11-27T19:13:53Z
1763-11-07T03:45:07Z
3777-09-02T14:59:16Z
2590-02-06T20:33:37Z
3511-12-01T22:12:22Z
0550-12-31T11:19:02Z
3635-01-20T08:28:05Z
3085-03-09T14:00:29Z
0855-05-10T03:53:06Z
1177-11-08T21:40:06Z
1619-06-04T05:51:37Z
1875-05-13T04:08:01Z
3861-03-09T00:29:10Z
0863-05-11T06:00:31Z
3426-04-07T15:38:37Z
"""
        .components(separatedBy: "\n")

    @Test("Test Against 100 ISO8601 Strings")
    func asISO8601_outputs_proper_string() async throws {

        let formatter = ISO8601DateFormatter()

        for dateString in exampleISO8601Strings {
            let date = formatter.date(from: dateString)
            #expect(date?.asISO8601 == dateString)
        }
    }
    
    struct Instance {
        let input: Date
        let expected: String
    }
    
    // use this to output a list of strings to the console that we can use as input in a test
    @Test
    func convertToInstance() {
        
        let formatter = ISO8601DateFormatter()
        
        for dateString in exampleISO8601Strings {
            let date = formatter.date(from: dateString)
            let time = date?.timeIntervalSince1970
            print("Instance(input: Date(timeIntervalSince1970: \(Int(time!))), expected: \"\(dateString)\"),")
        }
    }
    
    @Test("Test Against Known Output", arguments: [
        Instance(input: Date(timeIntervalSince1970: -40241318220), expected: "0694-10-18T00:03:00Z"),
        Instance(input: Date(timeIntervalSince1970: 36571335925), expected: "3128-11-25T08:25:25Z"),
        Instance(input: Date(timeIntervalSince1970: 18980973526), expected: "2571-06-26T04:38:46Z"),
        Instance(input: Date(timeIntervalSince1970: 52003658165), expected: "3617-12-06T04:36:05Z"),
        Instance(input: Date(timeIntervalSince1970: 56358499232), expected: "3755-12-06T10:40:32Z"),
        Instance(input: Date(timeIntervalSince1970: -62133779134), expected: "0001-01-24T00:54:26Z"),
        Instance(input: Date(timeIntervalSince1970: 10439159812), expected: "2300-10-21T14:36:52Z"),
        Instance(input: Date(timeIntervalSince1970: 51288969540), expected: "3595-04-14T07:59:00Z"),
        Instance(input: Date(timeIntervalSince1970: -30827593448), expected: "0993-02-05T03:35:52Z"),
        Instance(input: Date(timeIntervalSince1970: 7109053107), expected: "2195-04-11T16:58:27Z")
    ])
    func outputs_expected_result(instance: Instance) async throws {
        #expect(instance.input.asISO8601 == instance.expected)
    }
}

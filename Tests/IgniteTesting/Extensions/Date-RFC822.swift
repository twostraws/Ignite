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

    private let exampleRFC822Strings = """
Sun, 30 Aug 0571 00:15:07 -045602
Thu, 31 Oct 1793 12:35:57 -045602
Mon, 07 Aug 1531 06:42:55 -045602
Tue, 27 Jan 1439 12:41:30 -045602
Thu, 25 Jul 1861 14:59:27 -045602
Fri, 04 Feb 0438 04:22:44 -045602
Wed, 14 Dec 2833 02:41:00 -0500
Tue, 28 Jul 3716 15:29:01 -0400
Fri, 15 Dec 3015 20:09:22 -0500
Mon, 26 Oct 0274 03:31:02 -045602
Fri, 26 May 3623 20:39:48 -0400
Fri, 27 May 1043 05:00:51 -045602
Mon, 10 Feb 0811 20:08:38 -045602
Sun, 02 May 3069 13:06:59 -0400
Thu, 19 May 1932 18:25:54 -0400
Fri, 02 Aug 0020 16:01:05 -045602
Mon, 03 Mar 1533 03:35:18 -045602
Fri, 21 Nov 3124 13:47:41 -0500
Mon, 05 Feb 2863 03:49:42 -0500
Fri, 21 Nov 3569 06:25:28 -0500
Wed, 04 Feb 1807 05:46:48 -045602
Fri, 26 Dec 0923 04:07:12 -045602
Thu, 07 Nov 0978 22:09:23 -045602
Sun, 09 Oct 0427 08:44:04 -045602
Wed, 09 Jan 0816 16:23:11 -045602
Wed, 22 Mar 0892 08:56:39 -045602
Wed, 24 Feb 3610 15:45:20 -0500
Fri, 01 May 2950 14:04:04 -0400
Mon, 13 Nov 1301 19:37:04 -045602
Tue, 01 Nov 3757 08:48:41 -0400
Mon, 18 Mar 2041 15:42:03 -0400
Sat, 06 Nov 3300 19:40:07 -0400
Wed, 04 Apr 2435 11:07:13 -0400
Sat, 07 Dec 3101 20:08:50 -0500
Tue, 22 Mar 0208 00:59:03 -045602
Sat, 17 Apr 1999 09:50:37 -0400
Wed, 23 Jun 0314 21:14:00 -045602
Wed, 18 Sep 3907 16:12:40 -0400
Mon, 17 Jan 3577 08:49:04 -0500
Sun, 31 Jul 1887 09:12:45 -0500
Thu, 21 Aug 3073 03:18:55 -0400
Tue, 29 May 2063 17:50:06 -0400
Mon, 26 Mar 3151 19:04:42 -0400
Mon, 29 Mar 1858 17:03:44 -045602
Sat, 06 Feb 0398 10:42:40 -045602
Mon, 28 Jan 0457 21:40:18 -045602
Sat, 20 Mar 1339 01:22:51 -045602
Fri, 30 Apr 1858 22:54:18 -045602
Tue, 04 Jul 3516 08:46:15 -0400
Tue, 24 Apr 0949 14:47:04 -045602
Tue, 21 Feb 1939 19:37:23 -0500
Sun, 16 Jun 3280 08:13:52 -0400
Mon, 26 Jul 1745 09:29:24 -045602
Sun, 11 Feb 2548 13:45:29 -0500
Sat, 25 Aug 3787 15:31:57 -0400
Thu, 04 Sep 3597 15:34:18 -0400
Wed, 25 Feb 3384 11:24:00 -0500
Sun, 12 Dec 0728 19:44:15 -045602
Tue, 05 Mar 0569 13:30:10 -045602
Sat, 21 Jun 0178 18:21:23 -045602
Wed, 13 Jun 3100 01:44:13 -0400
Mon, 14 Apr 2279 00:50:31 -0400
Tue, 10 Oct 1088 01:36:44 -045602
Wed, 09 Apr 0777 15:46:43 -045602
Sat, 21 Oct 3505 11:56:41 -0400
Sun, 09 Dec 3528 20:57:37 -0500
Fri, 12 Jun 1226 19:55:25 -045602
Thu, 28 Jun 3004 08:26:41 -0400
Sun, 16 Oct 1306 19:55:36 -045602
Wed, 12 Apr 0450 19:48:48 -045602
Thu, 21 Sep 1301 14:05:22 -045602
Thu, 01 May 2842 01:31:37 -0400
Sun, 22 Jul 2835 19:58:16 -0400
Sat, 20 Apr 2363 01:07:08 -0400
Sun, 17 Jul 2214 20:21:36 -0400
Fri, 13 Feb 1170 10:22:14 -045602
Mon, 14 Sep 2764 08:17:50 -0400
Thu, 29 Nov 0081 10:21:57 -045602
Sat, 17 Nov 0904 20:37:09 -045602
Mon, 17 Nov 0984 14:47:36 -045602
Sun, 12 Jan 3259 12:35:08 -0500
Sat, 28 Sep 2069 22:22:09 -0400
Fri, 27 Oct 0937 20:07:26 -045602
Wed, 10 Dec 1851 06:46:30 -045602
Tue, 06 Jun 0747 23:59:28 -045602
Mon, 30 Sep 2295 00:30:21 -0400
Wed, 29 Jul 2640 16:54:36 -0400
Wed, 19 Aug 0330 23:50:52 -045602
Wed, 04 Jun 2206 02:53:53 -0400
Mon, 26 May 1698 13:24:29 -045602
Tue, 17 Dec 3996 17:21:45 -0500
Sun, 19 Jul 0649 00:22:30 -045602
Sat, 29 Jan 3566 20:01:18 -0500
Sat, 18 Aug 3027 20:59:48 -0400
Tue, 13 May 2921 23:25:29 -0400
Fri, 25 May 0451 00:30:43 -045602
Tue, 22 Dec 2522 13:06:07 -0500
Sat, 06 May 3167 17:49:44 -0400
Fri, 04 Apr 3034 13:06:07 -0400
Fri, 31 Oct 1597 06:38:21 -045602
"""
        .components(separatedBy: "\n")

    @Test("Test Against 100 RFC822 Strings")
    func asRFC822_outputs_proper_string() async throws {

        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"

        for dateString in exampleRFC822Strings {
            let date = formatter.date(from: dateString)

            #expect(date?.asRFC822 == dateString)

        }
    }
}


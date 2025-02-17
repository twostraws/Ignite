//
// String-TestingHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension String {
    // no, this isn't appropriate for general HTML parsing,
    // but for our purposes, testing nested tags,
    // it should work fine
    func htmlTagWithCloseTag(_ tagName: String) -> (attributes: String, contents: String)? {
        // this force try is acceptable because it is known to succeed
        // if it does fail, then there is something wrong at the call site
        // (maybe tagName is malformed?)
        // swiftlint:disable:next force_try
        let regex = try! Regex("<\(tagName)(.*?)>(.*?)</\(tagName)>")

        guard let unwrapped = firstMatch(of: regex) else {
            return nil
        }

        return (attributes: String(unwrapped[1].substring ?? ""),
                contents: String(unwrapped[2].substring ?? ""))
    }

    // no, this isn't appropriate for general HTML parsing,
    // but for our purposes, testing output, it should work fine
    func htmlAttribute(named name: String) -> String? {
        // this force try is acceptable because it is known to succeed
        // if it does fail, then there is something wrong at the call site
        // (maybe tagName is malformed?)
        // swiftlint:disable:next force_try
        let regex = try! Regex("\(name)=\"(.*?)\"")

        guard let found = firstMatch(of: regex)?[1].substring else { return nil }
        return String(found)
    }
}

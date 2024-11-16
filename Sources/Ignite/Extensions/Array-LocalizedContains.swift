//
// Array-LocalizedContains.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Array where Element == String {
    /// Searches a string array to see whether it contains one particular string, 
    /// each time using the `localizedStandardContains()` method
    /// for smarter checks.
    func localizedContains(_ string: String) -> Bool {
        for item in self where item.localizedStandardContains(string) {
            return true
        }

        return false
    }
}

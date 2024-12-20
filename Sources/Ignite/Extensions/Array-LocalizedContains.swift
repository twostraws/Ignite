//
// Array-LocalizedContains.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension Array where Element == String {
    /// Searches a string array to see whether it contains one particular string, 
    /// each time using the `localizedStandardContains()` method
    /// for smarter checks.
    func localizedContains(_ string: String) -> Bool {
        self.contains { $0.localizedStandardContains(string) }
    }
}

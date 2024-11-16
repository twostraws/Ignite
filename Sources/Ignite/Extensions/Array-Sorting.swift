//
// Array-Sorting.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension Sequence {
    /// Extends `Sequence` to allow finding the maximum item using a
    /// function that accepts an item from the sequence and returns a
    ///  `Comparable` value. Particularly useful when used with key paths.
    /// - Parameters:
    ///   - function: The function to apply to each element. Must yield a
    /// `Comparable` value.
    /// - Returns: The maximum item in the sequence, or nil if the
    /// sequence was empty.
    public func min<T: Comparable>(by function: (Element) -> T) -> Element? {
        self.min { first, second in
            function(first) < function(second)
        }
    }

    /// Extends `Sequence` to allow finding the maximum item using a
    /// function that accepts an item from the sequence and returns a
    ///  `Comparable` value. Particularly useful when used with key paths.
    /// - Parameters:
    ///   - function: The function to apply to each element. Must yield a
    /// `Comparable` value.
    /// - Returns: The maximum item in the sequence, or nil if the
    /// sequence was empty.
    public func max<T: Comparable>(by function: (Element) -> T) -> Element? {
        self.max { first, second in
            function(first) < function(second)
        }
    }

    /// Extends `Sequence` to allow sorting items by a function that accepts
    /// an item from the sequence and returns a `Comparable` value.
    /// Particularly useful when used with key paths.
    /// - Parameters:
    ///   - function: The function to apply to each element. Must yield a
    /// `Comparable` value.
    ///   - order: Whether to sort in forward or reverse order.
    /// - Returns: A sorted array of items from the sequence.
    public func sorted<T: Comparable>(by function: (Element) -> T, order: SortOrder = .forward) -> [Element] {
        self.sorted { first, second in
            if order == .forward {
                function(first) < function(second)
            } else {
                function(first) > function(second)
            }
        }
    }
}

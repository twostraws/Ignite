//
// Typealiases.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import OrderedCollections

// A typealias that allows us to use `OrderedSet` without importing OrderedCollections
public typealias OrderedSet<Element: Hashable> = OrderedCollections.OrderedSet<Element>

// A typealias that allows us to use `OrderedDictionary` without importing OrderedCollections
public typealias OrderedDictionary<Key: Hashable, Value> = OrderedCollections.OrderedDictionary<Key, Value>

// A typealias that allows us to use `UUID` without importing Foundation
public typealias UUID = Foundation.UUID

// A typealias that allows us to use `URL` without importing Foundation
public typealias URL = Foundation.URL

// A typealias that allows us to use `Data` without importing Foundation
public typealias Data = Foundation.Data

// A typealias that allows us to use `Date` without importing Foundation
public typealias Date = Foundation.Date

//
//  Date-ISO8601.swift
//  
//
//  Created by Jobert Sá on 24/05/2024.
//

import Foundation

extension Date {
    /// Converts `Date` objects to ISO 8601 format.
    public var asISO8601: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}

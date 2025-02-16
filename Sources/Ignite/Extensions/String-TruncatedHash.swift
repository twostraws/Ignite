//
// String-TruncatedHash.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Creates a 5-character hash string that persists between app launches (e.g. "Hello World" -> "5eb21")
extension String {
   var truncatedHash: String {
       let hash = strHash(self)

       // Create a deterministic string from the hash
       let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
       var result = ""
       var remainingHash = hash

       // Generate exactly 5 characters
       for _ in 0..<5 {
           let index = Int(remainingHash % UInt64(charset.count))
           result.append(charset[index])
           remainingHash /= UInt64(charset.count)
       }

       return result
   }

   private func strHash(_ str: String) -> UInt64 {
       var result = UInt64(5381)
       let characters = [UInt8](str.utf8)

       for character in characters {
           result = 127 * (result & 0x00ffffffffffffff) + UInt64(character)
       }

       return result
   }
}

//
// OrderedListStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Some of the (many!) ways of numbering ordered lists.
public enum OrderedListStyle: String {
    /// Lists are numbered 1, 2, 3
    case `default` = "decimal"

    /// Lists are numbered in traditional Armenian numbers.
    case armenian = "armenian"

    /// Lists are numbered using traditional Chinese characters.
    case cjkIdeographic = "cjk-ideographic"

    /// Lists are numbered with decimals starting with a leading zero.
    case decimalLeadingZero = "decimal-leading-zero"

    /// Lists are numbered in traditional Georgian numbers.
    case georgian = "georgian"

    /// Lists are numbered in traditional Hebrew numbers.
    case hebrew = "hebrew"

    /// Lists are numbered in hiragana using dictionary ordering.
    case hiragana = "hiragana"

    /// Lists are numbered in hiragana using iroha ordering.
    case hiraganaIroha = "hiragana-iroha"

    /// Lists are numbered in katakana using dictionary ordering.
    case katakana = "katakana"

    /// Lists are numbered in katakana using iroha ordering.
    case katakanaIroha = "katakana-iroha"

    /// Lists are numbered using lowercase ASCII letters.
    case lowerAlphabet = "lower-alpha"

    /// Lists are numbered using lowercase classical Greek letters.
    case lowerGreek = "lower-greek"

    /// Lists are numbered using lowercase ASCII letters.
    case lowerLatin = "lower-latin"

    /// Lists are numbered using lowercase Roman numerals.
    case lowerRoman = "lower-roman"

    /// Lists are numbered using uppercase ASCII letters.
    case upperAlphabet = "upper-alpha"

    /// Lists are numbered using uppercase ASCII letters.
    case upperLatin = "upper-latin"

    /// Lists are numbered using uppercase Roman numerals.
    case upperRoman = "upper-roman"
}

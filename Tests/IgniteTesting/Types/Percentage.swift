//
//  Percentage.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Percentage` type.
@Suite("Percentage Tests")
@MainActor
struct PercentageTests {
    @Test("Test the value property.", arguments: [
        25,
        74.3,
        -126.225
    ])
    func value(value: Double) async throws {
        let element = Percentage(value)

        #expect(element.value == value)
    }

    @Test("Test the value function.", arguments: [
        (2, Percentage(25.12345678390987), 25.12),
        (5, Percentage(25.12345678390987), 25.12346),
        (10, Percentage(25.12345678390987), 25.1234567839)
    ])
    func value(decimals: Int, percent: Percentage, expected: Double) async throws {
        #expect(percent.value(decimals: decimals) == expected)
    }

    @Test("Test the rounded value.", arguments: [
        (Percentage(25.4), 25),
        (Percentage(25.499999), 25),
        (Percentage(25.5), 26)
    ])
    func roundedValue(percent: Percentage, expected: Int) async throws {
        #expect(percent.roundedValue == expected)
    }

    @Test("Test subtracting percentages.", arguments: [
        (Percentage(25.4), Percentage(22.4), 3.0),
        (Percentage(16.335), Percentage(49), -32.665),
        (Percentage(77), Percentage(-23), 100.0)
    ])
    func subtract(minuend: Percentage, subtrahend: Percentage, expected: Double) async throws {
        #expect(minuend - subtrahend == expected)
    }

    @Test("Test adding percentages.", arguments: [
        (Percentage(25.4), Percentage(22.4), 47.8),
        (Percentage(16.335), Percentage(49), 65.335),
        (Percentage(77), Percentage(-23), 54.0)
    ])
    func add(firstAddend: Percentage, secondAddend: Percentage, expected: Double) async throws {
        #expect(abs(firstAddend + secondAddend - expected) < 0.000001)
    }

    @Test("Test multiplying percentages.", arguments: [
        (2.0, Percentage(25.4), 0.508),
        (-3.0, Percentage(16.335), -0.49005),
        (10.0, Percentage(77), 7.70)
    ])
    func multiply(factor: Double, percent: Percentage, expected: Double) async throws {
        #expect(abs(factor * percent - expected) < 0.000001)
        #expect(abs(percent * factor - expected) < 0.000001)
    }

    @Test("Test % postfix operator on doubles.", arguments: [
        25.4,
        83.49999,
        69.5
    ])
    func percentagePostfixDouble(value: Double) async throws {
        #expect(value% == Percentage(value))
    }

    @Test("Test % postfix operator on integers.", arguments: [
        25,
        83,
        69
    ])
    func percentagePostfixInt(value: Int) async throws {
        #expect(value% == Percentage(value))
    }

    @Test("Test comparable operator.", arguments: [
        (Percentage(20), Percentage(21), true),
        (Percentage(20), Percentage(19), false),
        (Percentage(20), Percentage(-19), false)
    ])
    func comparable(lhs: Percentage, rhs: Percentage, expected: Bool) async throws {
        #expect((lhs < rhs) == expected)
        #expect((lhs > rhs) == !expected)
    }

    @Test("Test equality operator.", arguments: [
        (Percentage(20), Percentage(21), false),
        (Percentage(20), Percentage(19), false),
        (Percentage(20), Percentage(-19), false),
        (Percentage(20), Percentage(20), true)
    ])
    func equality(lhs: Percentage, rhs: Percentage, expected: Bool) async throws {
        #expect((lhs == rhs) == expected)
    }

    @Test("Test BinaryFloatingPoint extension.", arguments: [
        20.88,
        -33.12,
        125.54321
    ])
    func asString(value: Double) async throws {
        let element = Percentage(value)
        #expect(element.value.asString() == "\(value)%")
    }

    @Test("Test BinaryInteger extension.", arguments: [
        20,
        -33,
        125
    ])
    func asString(value: Int) async throws {
        let element = Percentage(value)
        #expect(element.roundedValue.asString() == "\(value)%")
    }
}

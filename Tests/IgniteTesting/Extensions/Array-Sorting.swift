//
//  Array-Sorting.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Array-Sorting` extension.
@Suite("Array-Sorting Tests")
@MainActor
struct ArraySortingTests {
    @MainActor

    // MARK: Tests for a simple custom type.
    // Given
    struct Apple {
        let weight: Int
        let color: String
    }

    let apples = [
        Apple(weight: 120, color: "Yellow"),
        Apple(weight: 160, color: "Red"),
        Apple(weight: 150, color: "Red"),
        Apple(weight: 180, color: "Green")
    ]

    @Test("Find the lightest apple by weight")
    func minBy_findLightestApple() async throws {
        // When
        let result = apples.min(by: \.weight)
        // Then
        #expect(result?.weight == 120)
    }

    @Test("Find the heaviest apple by weight")
    func maxBy_findHeaviestApple() async throws {
        // When
        let result = apples.max(by: \.weight)
        // Then
        #expect(result?.weight == 180)
    }

    @Test("Find 'min' apple colour")
    func minBy_findMinColor() async throws {
        // When
        let result = apples.min(by: \.color)
        // Then
        #expect(result?.color == "Green")
    }

    @Test("Find 'max' apple color")
    func maxBy_findMaxColor() async throws {
        // When
        let result = apples.max(by: \.color)
        // Then
        #expect(result?.color == "Yellow")
    }

    @Test("Sort apples by weight in ascending order")
    func sortApplesByWeightInAscendingOrder() async throws {
        // When
        let result = apples.sorted(by: \.weight, order: .forward)
        // Then
        #expect(result.map { $0.weight } == [120, 150, 160, 180])
    }

    @Test("Sort apples by weight in descending order")
    func sortApplesByWeightInDescendingOrder() async throws {
        // When
        let result = apples.sorted(by: \ .weight, order: .reverse)
        // Then
        #expect(result.map { $0.weight } == [180, 160, 150, 120])
    }

    @Test("Sort apples by colour in ascending order")
    func sortApplesByColorInAscendingOrder() async throws {
        // When
        let result = apples.sorted(by: \ .color, order: .forward)
        // Then
        #expect(result.map { $0.color } == ["Green", "Red", "Red", "Yellow"])
    }

    @Test("Sort apples by colour in descending order")
    func sortApplesByColorInDescendingOrder() async throws {
        // When
        let result = apples.sorted(by: \ .color, order: .reverse)
        // Then
        #expect(result.map { $0.color } == ["Yellow", "Red", "Red", "Green"])
    }

    // MARK: Tests for another simple custom type.
    // Given
    struct Car {
        let model: String
        let horsepower: Int
        let price: Double
    }

    let cars = [
        Car(model: "Hatchback", horsepower: 130, price: 18000),
        Car(model: "Sedan", horsepower: 150, price: 20000),
        Car(model: "Coupé", horsepower: 180, price: 30000),
        Car(model: "SUV", horsepower: 200, price: 35000)
    ]

    @Test("Find the highest horsepower")
    func maxBy_findHighestHorsepower() async throws {
        // When
        let result = cars.max(by: \.horsepower)
        // Then
        #expect(result?.horsepower == 200)
    }

    @Test("Find the lowest horsepower")
    func minBy_findLowestHorsepower() async throws {
        // When
        let result = cars.min(by: \.horsepower)
        // Then
        #expect(result?.horsepower == 130)
    }

    @Test("Find the cheapest price")
    func minBy_findCheapestPrice() async throws {
        // When
        let result = cars.min(by: \.price)
        // Then
        #expect(result?.price == 18000)
    }

    @Test("Find the most expensive price")
    func maxBy_findMostExpensivePrice() async throws {
        // When
        let result = cars.max(by: \.price)
        // Then
        #expect(result?.price == 35000)
    }

    @Test("Sort cars by price in descending order")
    func sortCarsByPriceInDescendingOrder() async throws {
        // When
        let result = cars.sorted(by: \.price, order: .reverse)
        // Then
        #expect(result.map { $0.model } == ["SUV", "Coupé", "Sedan", "Hatchback"])
    }

    @Test("Sort cars by power in ascedning order")
    func sortCarsByPowerInAscendingOrder() async throws {
        // When
        let result = cars.sorted(by: \.horsepower, order: .forward)
        // Then
        #expect(result.map { $0.model } == ["Hatchback", "Sedan", "Coupé", "SUV"])
    }

    @Test("Min, max, and sort on an empty sequence")
    func operationsOnEmptySequence_returnNilOrEmpty() async throws {
        // Given
        let emptyBasket: [Apple] = []
        let emptyCars: [Car] = []

        // When
        // #1
        let minBasketResult = emptyBasket.min(by: \.weight)
        let maxBasketResult = emptyBasket.max(by: \.weight)
        let sortedBasketResult = emptyBasket.sorted(by: \.weight)
        // #2
        let minCarResult = emptyCars.min(by: \.price)
        let maxCarResult = emptyCars.max(by: \.price)
        let sortedCarsResult = emptyCars.sorted(by: \.price)

        // Then
        // #1
        #expect(minBasketResult == nil)
        #expect(maxBasketResult == nil)
        #expect(sortedBasketResult.isEmpty)
        // #2
        #expect(minCarResult == nil)
        #expect(maxCarResult == nil)
        #expect(sortedCarsResult.isEmpty)
    }

    // MARK: Tests for an HTML conforming type.
    // Given
    struct MockHTML: HTML {
        var id: String
        var isPrimitive: Bool = Bool.random()
        var body: some HTML { self }
        func render() -> String { "<div id=\"\(id)\"></div>" }
    }

    let mockHTMLElements = [
        MockHTML(id: "a"),
        MockHTML(id: "b"),
        MockHTML(id: "c")
    ]

    @Test("Finding min element by id")
    func minElementById() async throws {
        // When
        let result = mockHTMLElements.min(by: \.id)
        // Then
        #expect(result?.id == "a")
    }

    @Test("Finding max element by id")
    func maxElementById() async throws {
        // When
        let result = mockHTMLElements.max(by: \.id)
        // Then
        #expect(result?.id == "c")
    }

    @Test("Sort elements by id in ascending order")
    func sortById_inAscendingOrder() async throws {
        // When
        let result = mockHTMLElements.sorted(by: \.id)
        // Then
        #expect(result.map { $0.id } == ["a", "b", "c"])
    }

    @Test("Sort elements by id in descending order")
    func sortById_inDescendingOrder() async throws {
        // When
        let result = mockHTMLElements.sorted(by: \.id, order: .reverse)
        // Then
        #expect(result.map { $0.id } == ["c", "b", "a"])
    }

    @Test("Sorting elements in-place by id in ascending order")
    func inPlaceSort_byIdInAscendingOrder() async throws {
        // Given
        var mutableMockHTMLElements = mockHTMLElements
        // When
        mutableMockHTMLElements.sort(by: \.id)
        // Then
        #expect(mutableMockHTMLElements.map { $0.id } == ["a", "b", "c"])
    }

    @Test("Sorting elements in-place by id in descending order")
    func inPlaceSort_byIdInDescendingOrder() async throws {
        // Given
        var mutableMockHTMLElements = mockHTMLElements
        // When
        mutableMockHTMLElements.sort(by: \.id, order: .reverse)
        // Then
        #expect(mutableMockHTMLElements.map { $0.id } == ["c", "b", "a"])
    }

    @Test("Empty HTML sequence for min")
    func minOnEmptySequence() async throws {
        // Given
        let emptyElements: [MockHTML] = []
        // When
        let result = emptyElements.min(by: \.id)
        // Then
        #expect(result == nil)
    }

    @Test("Empty HTML sequence for max")
    func maxOnEmptySequence() async throws {
        // Given
        let emptyElements: [MockHTML] = []
        // When
        let result = emptyElements.max(by: \.id)
        // Then
        #expect(result == nil)
    }

    @Test("Empty HTML sequence for sorting")
    func sortedOnEmptySequence() async throws {
        // Given
        let emptyElements: [MockHTML] = []
        // When
        let result = emptyElements.sorted(by: \.id)
        // Then
        #expect(result.isEmpty)
    }

    // MARK: Just some generic tests.
    // Given
    let testArray = [3, 1, 4, 1, 5, 9, 2]
    let expectedAscending = [1, 1, 2, 3, 4, 5, 9]
    let expectedDescending = [9, 5, 4, 3, 2, 1, 1]

    @Test("Integers, ascending")
    func sortIntegersAscending() async throws {
        // When
        let result = testArray.sorted(by: \.self)
        // Then
        #expect(result == expectedAscending)
    }

    @Test("Integers, descending")
    func sortIntegersDescending() async throws {
        // When
        let result = testArray.sorted(by: \.self, order: .reverse)
        // Then
        #expect(result == expectedDescending)
    }

    @Test("Integers, in-place, ascending")
    func inPlaceSort_integersAscending() async throws {
        // Given
        var myArray = testArray
        // When
        myArray.sort(by: \.self)
        // Then
        #expect(myArray == expectedAscending)
    }

    @Test("Integers, in-place, descending")
    func inPlaceSort_integersDescending() async throws {
        // Given
        var myArray = testArray
        // When
        myArray.sort(by: \.self, order: .reverse)
        // Then
        #expect(myArray == expectedDescending)
    }
}

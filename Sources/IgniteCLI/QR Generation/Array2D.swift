//
// Array2D.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A generic 2D array implementation.
struct Array2D<T> {
    /// The number of columns in the array.
    let columns: Int

    /// The number of rows in the array.
    let rows: Int

    /// The underlying storage.
    private var array: [T]

    /// The array data as a flattened array.
    var flattened: [T] { array }

    /// Creates a 2D array with the specified dimensions and initial value.
    /// - Parameters:
    ///   - rows: The number of rows.
    ///   - columns: The number of columns.
    ///   - initialValue: The value to fill the array with.
    init(rows: Int, columns: Int, initialValue: T) {
        self.rows = rows
        self.columns = columns
        self.array = .init(repeating: initialValue, count: rows*columns)
    }

    /// Creates a 2D array from a flattened array.
    /// - Parameters:
    ///   - rows: The number of rows.
    ///   - columns: The number of columns.
    ///   - flattened: The data as a flattened array.
    init(rows: Int, columns: Int, flattened: [T]) {
        precondition(
            rows * columns == flattened.count,
            "row/column counts don't match initial flattened data count")
        self.rows = rows
        self.columns = columns
        self.array = flattened
    }

    /// Access individual cells in the array.
    /// - Parameters:
    ///   - row: The row index.
    ///   - column: The column index.
    subscript(row: Int, column: Int) -> T {
        get {
            precondition(
                row < self.rows,
                "Row \(row) Index is out of range. Array2D<T>(rows:\(rows), columns: \(columns))")
            precondition(
                column < self.columns,
                "Column \(column) Index is out of range. Array2D<T>(rows:\(rows), columns: \(columns))")
            return self.array[(row * self.columns) + column]
        }
        set {
            precondition(
                row < self.rows,
                "Row \(row) Index is out of range. Array2D<T>(rows:\(rows), columns: \(columns))")
            precondition(
                column < self.columns,
                "Column \(column) Index is out of range. Array2D<T>(rows:\(rows), columns: \(columns))")
            self.array[(row * self.columns) + column] = newValue
        }
    }
}

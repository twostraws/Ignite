//
// BoolMatrix.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A class that represents a square boolean matrix for QR code data.
///
/// `BoolMatrix` provides a convenient way to access and manipulate the binary data
/// that makes up a QR code.
struct BoolMatrix {
    /// The underlying 2D array storage.
    private var content: Array2D<Bool>

    /// Creates an empty boolean matrix.
    init() {
        self.content = Array2D(rows: 0, columns: 0, initialValue: false)
    }

    /// Creates a boolean matrix with the specified dimension.
    /// - Parameter dimension: The width and height of the square matrix.
    init(dimension: Int) {
        self.content = Array2D(rows: dimension, columns: dimension, initialValue: false)
    }

    /// Creates a boolean matrix from a flattened array.
    /// - Parameters:
    ///   - dimension: The width and height of the square matrix.
    ///   - flattened: The data as a flattened array.
    init(dimension: Int, flattened: [Bool]) {
        self.content = Array2D(rows: dimension, columns: dimension, flattened: flattened)
    }

    /// The width and height of the matrix.
    var dimension: Int { content.rows }

    /// The matrix data as a flattened array.
    var flattened: [Bool] { content.flattened }

    /// Access individual cells in the matrix.
    /// - Parameters:
    ///   - row: The row index.
    ///   - column: The column index.
    subscript(row: Int, column: Int) -> Bool {
        get { content[row, column] }
        set { content[row, column] = newValue }
    }
}

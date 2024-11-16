//
// Rotation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Defines the possible directions for 3D rotations
public enum Rotation {
    /// Rotates 360 degrees around the Y axis (left to right)
    case forward
    
    /// Rotates -360 degrees around the Y axis (right to left)
    case backward
    
    /// Rotates -360 degrees around the X axis (bottom to top)
    case up
    
    /// Rotates 360 degrees around the X axis (top to bottom)
    case down
}

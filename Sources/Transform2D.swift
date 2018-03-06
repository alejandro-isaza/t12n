// Copyright © 2018 Alejandro Isaza.
//
// This file is part of t12n. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import CoreGraphics

/// Definition of a 2D transformation.
public struct Transform2D: CustomStringConvertible, ExpressibleByArrayLiteral {
    /// Transformation steps.
    public var steps = [Operation2D]()

    /// Creates a new identify `Transform`.
    public init() {
        steps = []
    }

    /// Creates a new `Transform` with the given steps.
    public init(_ steps: [Operation2D]) {
        self.steps = steps
    }

    /// Creates a new `Transform` with the given steps.
    public init(arrayLiteral steps: Operation2D...) {
        self.steps = steps
    }

    /// Computes the inverse transform.
    public func inverted() -> Transform2D {
        return Transform2D(steps.reversed().map({ $0.inverse }))
    }

    /// Apply `self` to a point.
    public func apply(to point: CGPoint) -> CGPoint {
        var point = point
        for step in steps.reversed() {
            point = step.apply(to: point)
        }
        return point
    }

    /// Apply `self` to a vector.
    public func apply(to vector: CGVector) -> CGVector {
        var vector = vector
        for step in steps.reversed() {
            vector = step.apply(to: vector)
        }
        return vector
    }

    /// `CGAffineTransform` representation of this transformation.
    ///
    /// - Note: If `self` cannot be represented as a 2D affine transform the value is `nil`.
    public var matrix: CGAffineTransform {
        var t = CGAffineTransform.identity
        for step in steps.reversed() {
            t = t.concatenating(step.matrix)
        }
        return t
    }

    /// String representation of this transformation.
    public var description: String {
        var string = ""
        for step in steps {
            string += step.description
            string += " "
        }
        if string.hasSuffix(" ") {
            string.removeLast()
        }
        if string.isEmpty {
            return "identity"
        }
        return string
    }
}

// Copyright © 2018 Alejandro Isaza.
//
// This file is part of t12n. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.
// Copyright © 2018 JABT. All rights reserved.

import CoreGraphics

/// Specifies an individual operation of a 2D transformation.
///
/// - SeeAlso: `Transform2d`
public enum Operation2D: CustomStringConvertible {
    /// Translation operation
    case translate(CGFloat, CGFloat)

    /// Scale operation
    case scale(CGFloat, CGFloat)

    /// Rotation operation
    case rotate(Angle)

    /// Skew operation
    case skew(Angle, Angle)

    /// General 2D transformatiopn
    case matrix(CGAffineTransform)

    // MARK: - Helper factory methods

    /// Defines a translation, using only the value for the X-axis
    public static func translateX(_ x: CGFloat) -> Operation2D {
        return .translate(x, 0)
    }

    /// Defines a translation, using only the value for the Y-axis
    public static func translateY(_ y: CGFloat) -> Operation2D {
        return .translate(0, y)
    }

    /// Defines a scale transformation by giving a value for the X-axis
    public static func scaleX(_ x: CGFloat) -> Operation2D {
        return .scale(x, 1)
    }

    /// Defines a scale transformation by giving a value for the Y-axis
    public static func scaleY(_ y: CGFloat) -> Operation2D {
        return .scale(1, y)
    }

    /// Defines a 2D skew transformation along the X-axis
    public static func skewX(_ angle: Angle) -> Operation2D {
        return .skew(angle, Angle(radians: 0))
    }

    /// Defines a 2D skew transformation along the Y-axis
    public static func skewY(_ angle: Angle) -> Operation2D {
        return .skew(Angle(radians: 0), angle)
    }

    // MARK: -

    /// The inverse of `self`.
    public var inverse: Operation2D {
        switch self {
        case .translate(let x, let y):
            return .translate(-x, -y)
        case .scale(let sx, let sy):
            return .scale(1/sx, 1/sy)
        case .rotate(let angle):
            return .rotate(-angle)
        case .skew(let ax, let ay):
            return .skew(-ax, -ay)
        case .matrix(let affine):
            return .matrix(affine.inverted())
        }
    }

    /// Apply `self` to a point.
    public func apply(to point: CGPoint) -> CGPoint {
        switch self {
        case .translate(let x, let y):
            return CGPoint(x: point.x + x, y: point.y + y)
        case .scale(let sx, let sy):
            return CGPoint(x: point.x * sx, y: point.y * sy)
        case .rotate, .skew:
            let t = self.matrix
            return CGPoint(
                x: t.a * point.x + t.c * point.y + t.tx,
                y: t.b * point.x + t.d * point.y + t.ty)
        case .matrix(let affine):
            return point.applying(affine)
        }
    }

    /// Apply `self` to a vector.
    public func apply(to vector: CGVector) -> CGVector {
        switch self {
        case .translate:
            return vector
        case .scale(let sx, let sy):
            return CGVector(dx: vector.dx * sx, dy: vector.dy * sy)
        case .rotate, .skew:
            let t = self.matrix
            return CGVector(
                dx: t.a * vector.dx + t.c * vector.dy,
                dy: t.b * vector.dx + t.d * vector.dy)
        case .matrix(let t):
            return CGVector(
                dx: t.a * vector.dx + t.c * vector.dy,
                dy: t.b * vector.dx + t.d * vector.dy)
        }
    }

    /// `CGAffineTransform` representation of this operation.
    public var matrix: CGAffineTransform {
        switch self {
        case .translate(let x, let y):
            return CGAffineTransform(translationX: x, y: y)
        case .scale(let sx, let sy):
            return CGAffineTransform(scaleX: sx, y: sy)
        case .rotate(let angle):
            return CGAffineTransform(rotationAngle: angle.radians)
        case .skew(let ax, let ay):
            var skew = CGAffineTransform.identity
            skew.b = tan(ay.radians)
            skew.c = tan(ax.radians)
            return skew
        case .matrix(let affine):
            return affine
        }
    }

    /// String representation of this step.
    public var description: String {
        switch self {
        case .translate(let x, let y):
            if y == 0 {
                return String(format: "translateX(%g)", x)
            } else if x == 0 {
                return String(format: "translateY(%g)", y)
            } else {
                return String(format: "translate(%g, %g)", x, y)
            }
        case .scale(let sx, let sy):
            if sy == 1 {
                return String(format: "scaleX(%g)", sx)
            } else if sx == 1 {
                return String(format: "scaleY(%g)", sy)
            } else {
                return String(format: "scale(%g, %g)", sx, sy)
            }
        case .rotate(let angle):
            return String(format: "rotate(%g)", angle.degrees)
        case .skew(let ax, let ay):
            if ay.radians == 0 {
                return String(format: "skewX(%g)", ax.degrees)
            } else if ax.radians == 0 {
                return String(format: "skewY(%g)", ay.degrees)
            } else {
                return String(format: "skew(%g, %g)", ax.degrees, ay.degrees)
            }
        case .matrix(let affine):
            return String(format: "matrix([%g, %g, %g], [%g, %g, %g])", affine.a, affine.b, affine.tx, affine.c, affine.d, affine.ty)
        }
    }
}

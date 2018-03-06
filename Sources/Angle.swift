// Copyright © 2018 Alejandro Isaza.
//
// This file is part of t12n. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import CoreGraphics

public struct Angle: Hashable {
    static let π = Angle(radians: CGFloat.pi)

    /// Angle value in radians.
    public var radians: CGFloat

    /// Angle value in degrees.
    public var degrees: CGFloat {
        get {
            return radians * 180.0 / CGFloat.pi
        }
        set {
            radians = newValue * CGFloat.pi / 180.0
        }
    }

    public init(radians: CGFloat) {
        self.radians = radians
    }

    public init(degrees: CGFloat) {
        self.radians = degrees * CGFloat.pi / 180.0
    }

    public var hashValue: Int {
        return radians.hashValue
    }

    public var description: String {
        return "\(degrees) degrees"
    }

    public static func == (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.radians == rhs.radians
    }

    public static prefix func - (angle: Angle) -> Angle {
        return Angle(radians: -angle.radians)
    }

    public static func + (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.radians + rhs.radians)
    }

    public static func += (lhs: inout Angle, rhs: Angle) {
        lhs = Angle(radians: lhs.radians + rhs.radians)
    }

    public static func - (lhs: Angle, rhs: Angle) -> Angle {
        return Angle(radians: lhs.radians - rhs.radians)
    }

    public static func -= (lhs: inout Angle, rhs: Angle) {
        lhs = Angle(radians: lhs.radians - rhs.radians)
    }

    public static func * (lhs: CGFloat, rhs: Angle) -> Angle {
        return Angle(radians: lhs * rhs.radians)
    }

    public static func * (lhs: Angle, rhs: CGFloat) -> Angle {
        return Angle(radians: lhs.radians * rhs)
    }

    public static func / (lhs: Angle, rhs: CGFloat) -> Angle {
        return Angle(radians: lhs.radians / rhs)
    }
}

// Copyright © 2018 Alejandro Isaza.
//
// This file is part of t12n. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

@testable import t12n
import XCTest

class Transform2DTests: XCTestCase {
    let testTransform = Transform2D([
        .translate(10, 20),
        .scale(1.1, 1.2),
        .rotate(Angle(degrees: 15)),
        .skew(Angle(degrees: 5), Angle(degrees: 7)),
    ])

    func testIdentityDescription() {
        let t = Transform2D()
        XCTAssertEqual(t.description, "identity")
    }

    func testTranslationDescription() {
        let t = Transform2D([.translate(10, 20)])
        XCTAssertEqual(t.description, "translate(10, 20)")
    }

    func testTranslationXDescription() {
        let t = Transform2D([.translateX(10)])
        XCTAssertEqual(t.description, "translateX(10)")
    }

    func testTranslationYDescription() {
        let t = Transform2D([.translateY(10)])
        XCTAssertEqual(t.description, "translateY(10)")
    }

    func testScaleDescription() {
        let t = Transform2D([.scale(2, 3)])
        XCTAssertEqual(t.description, "scale(2, 3)")
    }

    func testScaleXDescription() {
        let t = Transform2D([.scaleX(10)])
        XCTAssertEqual(t.description, "scaleX(10)")
    }

    func testScaleYDescription() {
        let t = Transform2D([.scaleY(10)])
        XCTAssertEqual(t.description, "scaleY(10)")
    }

    func testRotateDescription() {
        let t = Transform2D([.rotate(Angle(degrees: 15))])
        XCTAssertEqual(t.description, "rotate(15)")
    }

    func testSkewDescription() {
        let t = Transform2D([.skew(Angle(degrees: 15), Angle(degrees: 20))])
        XCTAssertEqual(t.description, "skew(15, 20)")
    }

    func testSkewXDescription() {
        let t = Transform2D([.skewX(Angle(degrees: 15))])
        XCTAssertEqual(t.description, "skewX(15)")
    }

    func testSkewYDescription() {
        let t = Transform2D([.skewY(Angle(degrees: 15))])
        XCTAssertEqual(t.description, "skewY(15)")
    }

    func testDescription() {
        XCTAssertEqual(testTransform.description, "translate(10, 20) scale(1.1, 1.2) rotate(15) skew(5, 7)")
    }

    func testAffineTransform2DDescription() {
        let t = Transform2D([.matrix(CGAffineTransform.identity)])
        XCTAssertEqual(t.description, "matrix([1, 0, 0], [0, 1, 0])")
    }

    func testInvert() {
        let testTransform = Transform2D([
            .translate(10, 20),
            .scale(1.1, 1.2),
            .rotate(Angle(degrees: 15)),
        ])
        let inverted = testTransform.inverted()
        let actualMatrix = inverted.matrix
        let expectedMatrix = testTransform.matrix.inverted()

        XCTAssertEqual(actualMatrix.a, expectedMatrix.a, accuracy: 1e-10)
        XCTAssertEqual(actualMatrix.b, expectedMatrix.b, accuracy: 1e-10)
        XCTAssertEqual(actualMatrix.c, expectedMatrix.c, accuracy: 1e-10)
        XCTAssertEqual(actualMatrix.d, expectedMatrix.d, accuracy: 1e-10)
        XCTAssertEqual(actualMatrix.tx, expectedMatrix.tx, accuracy: 1e-10)
        XCTAssertEqual(actualMatrix.ty, expectedMatrix.ty, accuracy: 1e-10)
    }

    func testAffineTransform() {
        let t = Transform2D([
            .translate(10, 20),
            .scale(1.1, 1.2),
            .rotate(Angle(degrees: 15)),
        ])

        var affine = CGAffineTransform.identity
        affine = affine.translatedBy(x: 10, y: 20)
        affine = affine.scaledBy(x: 1.1, y: 1.2)
        affine = affine.rotated(by: Angle(degrees: 15).radians)

        XCTAssertEqual(t.matrix, affine)
    }

    func testTransformPoint() {
        let original = CGPoint(x: -1, y: 4)
        let transformed = testTransform.apply(to: original)
        let expected = original.applying(testTransform.matrix)
        XCTAssertEqual(transformed.x, expected.x, accuracy: 1e-15)
        XCTAssertEqual(transformed.y, expected.y, accuracy: 1e-15)
    }
}

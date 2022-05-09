//
//  CGColorTests.swift
//  CoreGraphicsKitTests
//
//  Created by Pedro José Pereira Vieito on 24/11/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

#if canImport(CoreGraphics)
import Foundation
import XCTest
import CoreGraphics
import CoreGraphicsKit

class CGColorTests: XCTestCase {
    func testCGColor() throws {
        let blackColor = CGColor.cgColor(hexRGB: "000000")
        XCTAssertNotNil(blackColor)
        XCTAssertEqual(blackColor?.alpha, 1)
        XCTAssertEqual(blackColor?.hexRGB, "#000000")
        XCTAssertEqual(blackColor?.hexRGB, CGColor.black.hexRGB)
        XCTAssertNotEqual(blackColor?.hexRGB, CGColor.green.hexRGB)

        let whiteColor = CGColor.cgColor(hexRGB: "#FFFFFF")
        XCTAssertNotNil(whiteColor)
        XCTAssertEqual(whiteColor?.alpha, 1)
        XCTAssertEqual(whiteColor?.hexRGB, "#FFFFFF")
        XCTAssertEqual(whiteColor?.hexRGB, CGColor.white.hexRGB)
        XCTAssertNotEqual(whiteColor?.hexRGB, CGColor.green.hexRGB)

        let redColor = CGColor.cgColor(hexRGB: "F00")
        XCTAssertNotNil(redColor)
        XCTAssertEqual(redColor?.alpha, 1)
        XCTAssertEqual(redColor?.hexRGB, "#FF0000")
        XCTAssertEqual(redColor?.hexRGB, CGColor.red.hexRGB)
        XCTAssertNotEqual(redColor?.hexRGB, CGColor.green.hexRGB)

        let greenColor = CGColor.cgColor(hexRGB: "#0F0")
        XCTAssertNotNil(greenColor)
        XCTAssertEqual(redColor?.alpha, 1)
        XCTAssertEqual(greenColor?.hexRGB, "#00FF00")
        XCTAssertEqual(greenColor?.hexRGB, CGColor.green.hexRGB)
        XCTAssertNotEqual(greenColor?.hexRGB, CGColor.blue.hexRGB)
        
        let alphaGreenColor = CGColor.cgColor(hexARGB: "#0000FF00")
        XCTAssertNotNil(alphaGreenColor)
        XCTAssertEqual(alphaGreenColor?.hexRGB, "#00FF00")
        XCTAssertEqual(alphaGreenColor?.alpha, 0)
        XCTAssertEqual(alphaGreenColor?.hexRGB, CGColor.green.hexRGB)
        XCTAssertNotEqual(alphaGreenColor?.hexRGB, CGColor.blue.hexRGB)

        XCTAssertNil(CGColor.cgColor(hexRGB: "00F0"))
        XCTAssertNil(CGColor.cgColor(hexRGB: "00000F0"))
        XCTAssertNil(CGColor.cgColor(hexRGB: "#00000F0"))
        XCTAssertNil(CGColor.cgColor(hexRGB: "AKB"))
        XCTAssertNil(CGColor.cgColor(hexRGB: "#AAAA"))
        XCTAssertNil(CGColor.cgColor(hexRGB: "#AA"))
        XCTAssertNil(CGColor.cgColor(hexRGB: "AA"))
        XCTAssertNil(CGColor.cgColor(hexARGB: "AAA"))
        XCTAssertNil(CGColor.cgColor(hexRGBA: "AAA"))
        XCTAssertNil(CGColor.cgColor(hexRGBA: "AAABB"))
        XCTAssertNil(CGColor.cgColor(hexRGBA: "AABBAA"))
        XCTAssertNil(CGColor.cgColor(hexRGBA: "AABB"))
        XCTAssertNil(CGColor.cgColor(hexRGBA: "#000FF00"))
    }
}
#endif

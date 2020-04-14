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
        let blackColor = CGColor.cgColor(hexRGB: "#000000")
        XCTAssertNotNil(blackColor)
        XCTAssertEqual(blackColor?.hexRGB, "#000000")
        XCTAssertEqual(blackColor?.hexRGB, CGColor.black.hexRGB)
        XCTAssertNotEqual(blackColor?.hexRGB, CGColor.green.hexRGB)

        let whiteColor = CGColor.cgColor(hexRGB: "#FFFFFF")
        XCTAssertNotNil(whiteColor)
        XCTAssertEqual(whiteColor?.hexRGB, "#FFFFFF")
        XCTAssertEqual(whiteColor?.hexRGB, CGColor.white.hexRGB)
        XCTAssertNotEqual(whiteColor?.hexRGB, CGColor.green.hexRGB)

        let redColor = CGColor.cgColor(hexRGB: "#FF0000")
        XCTAssertNotNil(redColor)
        XCTAssertEqual(redColor?.hexRGB, "#FF0000")
        XCTAssertEqual(redColor?.hexRGB, CGColor.red.hexRGB)
        XCTAssertNotEqual(redColor?.hexRGB, CGColor.green.hexRGB)

        let greenColor = CGColor.cgColor(hexRGB: "#00FF00")
        XCTAssertNotNil(greenColor)
        XCTAssertEqual(greenColor?.hexRGB, "#00FF00")
        XCTAssertEqual(greenColor?.hexRGB, CGColor.green.hexRGB)
        XCTAssertNotEqual(greenColor?.hexRGB, CGColor.blue.hexRGB)
    }
}
#endif

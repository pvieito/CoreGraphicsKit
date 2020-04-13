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
        XCTAssertEqual(blackColor?.hexColor, "#000000")
        XCTAssertEqual(blackColor?.hexColor, CGColor.black.hexColor)
        XCTAssertNotEqual(blackColor?.hexColor, CGColor.green.hexColor)

        let whiteColor = CGColor.cgColor(hexRGB: "#FFFFFF")
        XCTAssertNotNil(whiteColor)
        XCTAssertEqual(whiteColor?.hexColor, "#FFFFFF")
        XCTAssertEqual(whiteColor?.hexColor, CGColor.white.hexColor)
        XCTAssertNotEqual(whiteColor?.hexColor, CGColor.green.hexColor)

        let redColor = CGColor.cgColor(hexRGB: "#FF0000")
        XCTAssertNotNil(redColor)
        XCTAssertEqual(redColor?.hexColor, "#FF0000")
        XCTAssertEqual(redColor?.hexColor, CGColor.red.hexColor)
        XCTAssertNotEqual(redColor?.hexColor, CGColor.green.hexColor)

        let greenColor = CGColor.cgColor(hexRGB: "#00FF00")
        XCTAssertNotNil(greenColor)
        XCTAssertEqual(greenColor?.hexColor, "#00FF00")
        XCTAssertEqual(greenColor?.hexColor, CGColor.green.hexColor)
        XCTAssertNotEqual(greenColor?.hexColor, CGColor.blue.hexColor)
    }
}
#endif

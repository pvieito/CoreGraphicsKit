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
        let redColor = CGColor.cgColor(hexRGB: "#FF0000")
        XCTAssertNotNil(redColor)
        XCTAssertEqual(redColor?.cssColor, CGColor.red.cssColor)
        XCTAssertNotEqual(redColor?.cssColor, CGColor.green.cssColor)
        
        let greenColor = CGColor.cgColor(hexRGB: "#00FF00")
        XCTAssertNotNil(greenColor)
        XCTAssertEqual(greenColor?.cssColor, CGColor.green.cssColor)
        XCTAssertNotEqual(greenColor?.cssColor, CGColor.blue.cssColor)
    }
}
#endif

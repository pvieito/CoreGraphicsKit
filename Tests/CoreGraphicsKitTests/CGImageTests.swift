//
//  CGImageTests.swift
//  CoreGraphicsKitTests
//
//  Created by Pedro José Pereira Vieito on 05/01/2024.
//  Copyright © 2024 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import XCTest
import CoreGraphicsKit

class CGImageTests: XCTestCase {
    var testImage: CGImage!

    override func setUp() {
        super.setUp()
        self.testImage = createTestImage()
    }

    func createTestImage() -> CGImage {
        let width = 100
        let height = 100
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo: bitmapInfo)!
        context.setFillColor(CGColor(red: 1, green: 0, blue: 0, alpha: 1))
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        let image = context.makeImage()
        return image!
    }
    
    func testFillModeLargerTargetSize() throws {
        let targetSizes = [
            CGSize(width: 50, height: 50),
            CGSize(width: 50, height: 100),
            CGSize(width: 100, height: 50),
            CGSize(width: 200, height: 200),
            CGSize(width: 1000, height: 500),
        ]
        
        for targetSize in targetSizes {
            let resizedImage = try XCTUnwrap(testImage.resized(to: targetSize, mode: .fill))
            XCTAssertEqual(resizedImage.width, Int(targetSize.width))
            XCTAssertEqual(resizedImage.height, Int(targetSize.height))
        }
    }
}

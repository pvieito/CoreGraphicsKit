//
//  CGImageTests.swift
//  CoreGraphicsKitTests
//
//  Created by Pedro José Pereira Vieito on 05/01/2024.
//  Copyright © 2024 Pedro José Pereira Vieito. All rights reserved.
//

#if canImport(CoreGraphics)
import Foundation
import XCTest
@testable import CoreGraphicsKit

class CGImageTests: XCTestCase {
    static var testImageSize = CGSize(width: 100, height: 100)
    var testWhiteImage: CGImage!
    var testTransparentImage: CGImage!

    override func setUp() {
        super.setUp()
        self.testWhiteImage = createTestImage(red: 1, green: 1, blue: 1)
        self.testTransparentImage = createTestImage(alpha: 0)
    }

    func createTestImage(red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1) -> CGImage {
        let width = Int(Self.testImageSize.width)
        let height = Int(Self.testImageSize.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo: bitmapInfo)!
        context.setFillColor(CGColor(red: red, green: green, blue: blue, alpha: alpha))
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        let image = context.makeImage()
        return image!
    }
    
    func testHasAlphaChannel() throws {
        XCTAssertTrue(self.testWhiteImage.hasAlphaChannel)
        XCTAssertTrue(self.testTransparentImage.hasAlphaChannel)
    }
    
    func testHasAnyTransparency() throws {
        XCTAssertFalse(self.testWhiteImage.hasAnyTransparency)
        XCTAssertTrue(self.testTransparentImage.hasAnyTransparency)
    }
    
    func testResized() throws {
        let sourceSize = Self.testImageSize
        let targetSizes = [
            CGSize(width: 50, height: 50),
            CGSize(width: 50, height: 100),
            CGSize(width: 100, height: 50),
            CGSize(width: 200, height: 200),
            CGSize(width: 500, height: 1000),
            CGSize(width: 1000, height: 500),
        ]
        let modes = [CGImage.CroppingMode.fill, CGImage.CroppingMode.fit]
        
        for targetSize in targetSizes {
            for mode in modes {
                let resizedImage = try XCTUnwrap(testWhiteImage.resized(to: targetSize, mode: mode))
                XCTAssertEqual(resizedImage.width, Int(targetSize.width))
                XCTAssertEqual(resizedImage.height, Int(targetSize.height))
                
                switch mode {
                case .fill:
                    XCTAssertFalse(resizedImage.hasAnyTransparency)
                case .fit:
                    if sourceSize.ratio == targetSize.ratio {
                        XCTAssertFalse(resizedImage.hasAnyTransparency)
                    }
                    else {
                        if sourceSize.width <= targetSize.width && sourceSize.height <= targetSize.height {
                            let croppedImage = resizedImage.cropping(ratio: sourceSize.ratio, mode: .fill)!
                            XCTAssertFalse(croppedImage.hasAnyTransparency)
                        }
                        XCTAssertTrue(resizedImage.hasAnyTransparency)
                    }
                }
            }
        }
    }
}
#endif

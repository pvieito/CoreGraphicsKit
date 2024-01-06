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
        let context = CGContext.cgContext(size: Self.testImageSize)!
        context.setFillColor(CGColor(red: red, green: green, blue: blue, alpha: alpha))
        context.fill(CGRect(sizeFromZero: Self.testImageSize))
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
                var resizedImage = try XCTUnwrap(testWhiteImage.resized(to: targetSize))
                XCTAssertEqual(resizedImage.size, targetSize)
                XCTAssertFalse(resizedImage.hasAnyTransparency)

                resizedImage = try XCTUnwrap(testWhiteImage.resized(height: targetSize.height))
                XCTAssertEqual(resizedImage.size.height, targetSize.size.height)
                XCTAssertEqual(resizedImage.size.ratio, testWhiteImage.size.ratio)
                XCTAssertFalse(resizedImage.hasAnyTransparency)

                resizedImage = try XCTUnwrap(testWhiteImage.resized(width: targetSize.width))
                XCTAssertEqual(resizedImage.size.width, targetSize.size.width)
                XCTAssertEqual(resizedImage.size.ratio, testWhiteImage.size.ratio)
                XCTAssertFalse(resizedImage.hasAnyTransparency)

                resizedImage = try XCTUnwrap(testWhiteImage.resized(to: targetSize, mode: mode))
                XCTAssertEqual(resizedImage.size, targetSize)
                
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
    
    func testAddingTransparentBorder() throws {
        let originalImage = self.testWhiteImage!
        XCTAssertFalse(originalImage.hasAnyTransparency)
        
        let insetsList = [
            CGRect.EdgeInsets(top: 1, left: 0, bottom: 0, right: 0),
            CGRect.EdgeInsets(top: 0, left: 1, bottom: 0, right: 0),
            CGRect.EdgeInsets(top: 1, left: 0, bottom: 1, right: 0),
            CGRect.EdgeInsets(top: 0, left: 0, bottom: 0, right: 1),
        ]
        for insets in insetsList {
            let image = originalImage.addingTransparentBorder(insets: insets)!
            XCTAssertTrue(image.hasAnyTransparency)
        }
        
        let image = originalImage.addingTransparentBorder(insets: CGRect.EdgeInsets())!
        XCTAssertFalse(image.hasAnyTransparency)
    }
    
    func testWithBackgroundColor() throws {
        let originalImage = self.testTransparentImage!
        XCTAssertTrue(originalImage.hasAnyTransparency)
        XCTAssertFalse(originalImage.withBackgroundColor()!.hasAnyTransparency)
        XCTAssertFalse(originalImage.withBackgroundColor(.red)!.hasAnyTransparency)
        XCTAssertFalse(originalImage.withBackgroundColor(.blue)!.hasAnyTransparency)
        XCTAssertFalse(originalImage.withBackgroundColor(.green)!.hasAnyTransparency)
        XCTAssertFalse(originalImage.withBackgroundColor(.gray)!.hasAnyTransparency)
        XCTAssertFalse(originalImage.withBackgroundColor(.black)!.hasAnyTransparency)
        XCTAssertFalse(originalImage.withBackgroundColor(.white)!.hasAnyTransparency)
    }
    
    func testWithRoundedCorners() throws {
        let originalImage = self.testWhiteImage!
        XCTAssertFalse(originalImage.hasAnyTransparency)
        XCTAssertTrue(originalImage.withRoundedCorners()!.hasAnyTransparency)
        XCTAssertTrue(originalImage.withRoundedCorners(radius: 1)!.hasAnyTransparency)
        XCTAssertTrue(originalImage.withRoundedCorners(radius: 20)!.hasAnyTransparency)
        XCTAssertFalse(originalImage.withRoundedCorners(radius: 0)!.hasAnyTransparency)
    }
}
#endif

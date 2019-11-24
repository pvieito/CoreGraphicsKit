//
//  CGRatioTests.swift
//  CoreGraphicsKitTests
//
//  Created by Pedro José Pereira Vieito on 24/11/2019.
//  Copyright © 2019 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import XCTest
import CoreGraphicsKit

class CGRatioTests: XCTestCase {
    func testCGRatio() throws {
        let rectA = CGRect(x: 1, y: 3.4, width: 1.2, height: 2.4)
        XCTAssertEqual(rectA.ratio, 0.5)
        
        let rectB = rectA.scaled(by: 0.001)
        XCTAssertEqual(rectB.height, 2.4 * 0.001)
        XCTAssertEqual(rectB.width, 1.2 * 0.001)
        XCTAssertEqual(rectB.ratio, 0.5)

        let sizeA = CGSize(width: 234, height: 234)
        XCTAssertEqual(sizeA.ratio, 1)
        
        let sizeB = CGSize(ratio: 2, width: 2)
        XCTAssertEqual(sizeB.width, 2)
        XCTAssertEqual(sizeB.height, 1)
        
        let sizeC = CGSize(ratio: 2, height: 2)
        XCTAssertEqual(sizeC.height, 2)
        XCTAssertEqual(sizeC.width, 4)
        
        let sizeD = sizeC.scaled(by: 1000)
        XCTAssertEqual(sizeD.height, 2 * 1000)
        XCTAssertEqual(sizeD.width, 4 * 1000)
        XCTAssertEqual(sizeD.ratio, 2)
    }
}

//
//  CGRect.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 10/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

extension CGRect {
    /// Initializes a CGRect with a given size box centered on a bouding box.
    ///
    /// - Parameters:
    ///   - centeredSize: Size of the new CGRect.
    ///   - boundingBox: Bounding box size where it should be centered.
    public init(size: CGSize, centeredOn boundingBox: CGRect) {
        let x = boundingBox.width / 2 + boundingBox.origin.x - size.width / 2
        let y = boundingBox.height / 2 + boundingBox.origin.y - size.height / 2
        let rectOrigin = CGPoint(x: x, y: y)
        self.init(origin: rectOrigin, size: size)
    }
}

extension CGRect: CGSizeProvider { }

extension CGRect: CGRatioProvider {

    /// The ratio between the width and the height of the size.
    public var ratio: CGRatio {
        return self.size.ratio
    }
}

extension CGRect: CGAreaProvider {

    /// Area of the CGRect.
    public var area: CGFloat {
        return self.size.width * self.size.height
    }
}

extension CGRect: CGScalable {

    /// Return a rect with the size scaled by a floating point factor.
    ///
    /// - Parameter scale: Scale factor.
    /// - Returns: Rect with the size scaled.
    public func scaled(by scale: CGFloat) -> CGRect {
        var rect = self
        rect.size = self.size * scale
        return rect
    }
}

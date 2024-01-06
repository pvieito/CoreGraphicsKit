//
//  CGRect.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 10/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

#if canImport(Darwin)
import CoreGraphics
#endif

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

extension CGRect {
    public var zeroOriginRect: CGRect {
        return self.size.zeroOriginRect
    }
}

extension CGRect: CGSizeProvider { }

extension CGRect: CGRatioProvider {
    /// The ratio between the width and the height of the size.
    public var ratio: CGRatio {
        return self.size.ratio
    }
}

extension CGRect {
    /// Center of the rect.
    public var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

extension CGRect: CGAreaProvider {
    /// Area of the CGRect.
    public var area: CGFloat {
        return self.size.width * self.size.height
    }
}

extension CGRect: CGScalable {
    /// Return a rect with the size scaled by a floating point factor, maintaining its origin point.
    ///
    /// - Parameter scale: Scale factor.
    /// - Returns: Rect with the size scaled, maintaining its origin point.
    public func scaled(by scale: CGFloat) -> CGRect {
        var rect = self
        rect.size = self.size * scale
        return rect
    }
}

extension CGRect {
    /// Return a rect with the size scaled by a floating point factor, maintaining its center point.
    ///
    /// - Parameter scale: Scale factor.
    /// - Returns: Rect with the size scaled, maintaining its center point.
    public func scaledFromCenter(by scale: CGFloat) -> CGRect {
        let scaledSize = self.size.scaled(by: scale)
        let originX = self.origin.x + (self.size.width - scaledSize.width) / 2
        let originY = self.origin.y + (self.size.height - scaledSize.height) / 2
        let scaledOrigin = CGPoint(x: originX, y: originY)
        return CGRect(origin: scaledOrigin, size: scaledSize.size)
    }
}

extension CGRect {
    public struct EdgeInsets {
        public var top: CGFloat
        public var left: CGFloat
        public var bottom: CGFloat
        public var right: CGFloat

        public init(top: CGFloat = .zero, left: CGFloat = .zero, bottom: CGFloat = .zero, right: CGFloat = .zero) {
            self.top = top
            self.left = left
            self.bottom = bottom
            self.right = right
        }
    }
}

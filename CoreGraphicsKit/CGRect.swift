//
//  CGRect.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 10/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

extension CGRect: CGScalable, CGRatioProvider {

    /// Return a rect with the size scaled by a floating point factor.
    ///
    /// - Parameter scale: Scale factor.
    /// - Returns: Rect with the size scaled.
    public func scaled(by scale: CGFloat) -> CGRect {
        var rect = self
        rect.size = self.size * scale

        return rect
    }

    /// The ratio between the width and the height of the size.
    public var ratio: CGRatio {
        return self.size.ratio
    }
}

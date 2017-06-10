//
//  CGSize.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 26/4/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGSize {

    /// Initializes a CGSize with a given ratio and width.
    ///
    /// - Parameters:
    ///   - ratio: Ratio of the size.
    ///   - width: Width of the size.
    public init(ratio: CGRatio, width: CGFloat) {
        self.init(width: width, height: width / ratio)
    }

    /// The biggest dimension of the size.
    public var max: CGFloat {
        return [self.width, self.height].max() ?? self.width
    }

    /// The smallest dimension of the size.
    public var min: CGFloat {
        return [self.width, self.height].min() ?? self.height
    }

    /// Size in portrait mode (withe the height bigger than the width)
    public var portrait: CGSize {
        return CGSize(width: self.min, height: self.max)
    }

    /// Size in landscape mode (withe the width bigger than the height)
    public var landscape: CGSize {
        return CGSize(width: self.max, height: self.min)
    }

    /// The size scaled by a floating point factor.
    static func * (size: CGSize, factor: CGFloat) -> CGSize {
        return CGSize(width: CGFloat(size.width) * factor, height: CGFloat(size.height) * factor)
    }

    /// The size scaled by a floating point factor.
    static func * (factor: CGFloat, size: CGSize) -> CGSize {
        return size * factor
    }
}

extension CGSize: CGSizeProvider {
    
    /// Basic CGSizeProvider implementation.
    public var size: CGSize {
        return self
    }
}

extension CGSize: CGRatioProvider {

    /// The ratio between the width and the height of the size.
    public var ratio: CGRatio {
        return self.width / self.height
    }
}

extension CGSize: CGAreaProvider {

    /// Area of the size.
    public var area: CGFloat {
        return self.width * self.height
    }
}

extension CGSize: CGScalable {
    
    /// Return the size scaled by a floating point factor.
    ///
    /// - Parameter scale: Scale factor.
    /// - Returns: Size scaled.
    public func scaled(by scale: CGFloat) -> CGSize {
        return self * scale
    }
}

extension CGSize: CustomStringConvertible {

    /// Formatted description of the size.
    public var description: String {
        return "\(self.width) × \(self.height)"
    }
}

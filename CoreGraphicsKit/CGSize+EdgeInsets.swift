//
//  CGSize+EdgeInsets.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 6/1/24.
//  Copyright © 2024 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

#if canImport(CoreGraphics)
import CoreGraphics
#endif

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

extension CGRect.EdgeInsets {
    public init(value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    public init(topAndBotton: CGFloat, leftAndRight: CGFloat) {
        self.init(top: topAndBotton, left: leftAndRight, bottom: topAndBotton, right: leftAndRight)
    }
}

extension CGRect.EdgeInsets: CGScalable {
    public func scaled(by scale: CGFloat) -> CGRect.EdgeInsets {
        var edgeInsets = self
        edgeInsets.top *= scale
        edgeInsets.bottom *= scale
        edgeInsets.left *= scale
        edgeInsets.right *= scale
        return edgeInsets
    }
}

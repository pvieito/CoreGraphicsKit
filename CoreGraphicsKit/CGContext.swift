//
//  CGImage.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 6/1/24.
//  Copyright © 2024 Pedro José Pereira Vieito. All rights reserved.
//

#if canImport(CoreGraphics)
import Foundation
import CoreGraphics

extension CGContext {
    public static func cgContext(data: UnsafeMutableRawPointer? = nil, width: Int, height: Int, bitsPerComponent: Int? = nil, bytesPerRow: Int? = nil, space: CGColorSpace? = nil, bitmapInfo: UInt32? = nil) -> CGContext? {
        let space = space?.supportsOutput == true ? space! : CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = bitmapInfo ?? CGImageAlphaInfo.premultipliedLast.rawValue
        return CGContext(data: data, width: width, height: height, bitsPerComponent: bitsPerComponent ?? 8, bytesPerRow: bytesPerRow ?? 0, space: space, bitmapInfo: bitmapInfo)
    }
        
    public static func cgContext(data: UnsafeMutableRawPointer? = nil, width: CGFloat, height: CGFloat, bitsPerComponent: Int? = nil, bytesPerRow: Int? = nil, space: CGColorSpace? = nil, bitmapInfo: UInt32? = nil) -> CGContext? {
        return self.cgContext(data: data, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: space, bitmapInfo: bitmapInfo)
    }
    
    public static func cgContext(data: UnsafeMutableRawPointer? = nil, size: CGSize, bitsPerComponent: Int? = nil, bytesPerRow: Int? = nil, space: CGColorSpace? = nil, bitmapInfo: UInt32? = nil) -> CGContext? {
        return self.cgContext(data: data, width: size.width, height: size.height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: space, bitmapInfo: bitmapInfo)
    }
}
#endif

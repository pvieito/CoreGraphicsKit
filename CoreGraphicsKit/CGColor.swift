//
//  CGColor.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 26/4/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import CoreGraphics

#if !os(macOS)
    import UIKit
#endif

extension CGColor {

    #if !os(macOS)
    public static func `init`(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> CGColor {

        return UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
    }

    public static func `init`(gray: CGFloat, alpha: CGFloat) -> CGColor {

        return UIColor(white: gray, alpha: alpha).cgColor
    }
    #endif

    /// Initializes a CGColor with an integer representing the alpha, red, green and blue channels.
    ///
    /// - Parameter argb: Integer with 8 bits per channels and alpha, red, green, blue channels order.
    /// - Returns: Initialized CGColor.
    public static func `init`(argb: UInt32) -> CGColor? {

        guard argb >= 0 && argb <= 0xFFFFFFFF else {
            return nil
        }

        return CGColor.init(red: CGFloat((argb >> 16) & 0xFF) / 255.0,
                            green: CGFloat((argb >> 8) & 0xFF) / 255.0,
                            blue: CGFloat((argb >> 0) & 0xFF) / 255.0,
                            alpha: CGFloat((argb >> 24) & 0xFF) / 255.0)
    }

    /// Initializes a CGColor with an integer representing the red, green, blue and alpha channels.
    ///
    /// - Parameter argb: Integer with 8 bits per channels and red, green, blue, alpha channels order.
    /// - Returns: Initialized CGColor.
    public static func `init`(rgba: UInt32) -> CGColor? {

        guard rgba >= 0 && rgba <= 0xFFFFFFFF else {
            return nil
        }

        return CGColor.init(red: CGFloat((rgba >> 24) & 0xFF) / 255.0,
                  green: CGFloat((rgba >> 16) & 0xFF) / 255.0,
                  blue: CGFloat((rgba >> 8) & 0xFF) / 255.0,
                  alpha: CGFloat((rgba >> 0) & 0xFF) / 255.0)
    }

    /// Initializes a CGColor with an integer representing the red, green and blue channels.
    ///
    /// - Parameter argb: Integer with 8 bits per channels and red, green, blue channels order.
    /// - Returns: Initialized CGColor with alpha set to 1.
    public static func `init`(rgb: Int) -> CGColor? {

        guard rgb >= 0 && rgb <= 0xFFFFFF else {
            return nil
        }

        return CGColor.init(red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
                            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
                            blue: CGFloat((rgb >> 0) & 0xFF) / 255.0,
                            alpha: 1)
    }

    /// Initializes a CGColor with an RGB hexadecimal representation.
    ///
    /// - Parameter hexARGB: ARGB hexadecimal representation, `#FF000000` or `FF000000`.
    /// - Returns: Initialized CGColor.
    public static func `init`(hexARGB: String) -> CGColor? {

        guard let colorInteger = hexARGB.hexadecimalColorInteger else {
            return nil
        }

        return CGColor.init(argb: UInt32(IntMax(colorInteger)))
    }

    /// Initializes a CGColor with an RGBA hexadecimal representation.
    ///
    /// - Parameter hexRGBA: RGBA hexadecimal representation, `#000000FF` or `000000FF`.
    /// - Returns: Initialized CGColor.
    public static func `init`(hexRGBA: String) -> CGColor? {

        guard let colorInteger = hexRGBA.hexadecimalColorInteger else {
            return nil
        }

        return CGColor.init(rgba: UInt32(IntMax(colorInteger)))
    }

    /// Initializes a CGColor with an RGB hexadecimal representation.
    ///
    /// - Parameter hexRGB: RGB hexadecimal representation, `#FFFFFF` or `FFFFFF`.
    /// - Returns: Initialized CGColor with alpha set to 1.
    public static func `init`(hexRGB: String) -> CGColor? {

        guard let colorInteger = hexRGB.hexadecimalColorInteger else {
            return nil
        }

        return CGColor.init(rgb: colorInteger)
    }

    /// Red color.
    public static var red: CGColor {
        return CGColor.init(red: 1, green: 0, blue: 0, alpha: 1)
    }

    /// Green color.
    public static var green: CGColor {
        return CGColor.init(red: 0, green: 1, blue: 0, alpha: 1)
    }

    /// Blue color.
    public static var blue: CGColor {
        return CGColor.init(red: 0, green: 0, blue: 1, alpha: 1)
    }

    /// Gray color.
    public static var gray: CGColor {
        return CGColor.init(gray: 0.5, alpha: 1)
    }
}

extension String {

    internal var hexadecimalColorInteger: Int? {
        let hexadecimalColorString = self.hasPrefix("#") ? self.substring(from: self.index(self.startIndex, offsetBy: 1)) : self

        return Int(hexadecimalColorString, radix: 16)
    }
}

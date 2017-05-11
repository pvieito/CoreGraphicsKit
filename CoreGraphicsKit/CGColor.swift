//
//  CGColor.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 26/4/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGColor {

    /// Initializes a CGColor with an integer representing the alpha, red, green and blue channels.
    ///
    /// - Parameter argb: Integer with 8 bits per channels and alpha, red, green, blue channels order.
    /// - Returns: Initialized CGColor.
    public static func `init`(argb: Int) -> CGColor {
        return CGColor.init(red: CGFloat((argb >> 16) & 0xFF) / 255.0,
                            green: CGFloat((argb >> 8) & 0xFF) / 255.0,
                            blue: CGFloat((argb >> 0) & 0xFF) / 255.0,
                            alpha: CGFloat((argb >> 24) & 0xFF) / 255.0)
    }

    /// Initializes a CGColor with an integer representing the red, green, blue and alpha channels.
    ///
    /// - Parameter argb: Integer with 8 bits per channels and red, green, blue, alpha channels order.
    /// - Returns: Initialized CGColor.
    public static func `init`(rgba: Int) -> CGColor {
        return CGColor.init(red: CGFloat((rgba >> 24) & 0xFF) / 255.0,
                  green: CGFloat((rgba >> 16) & 0xFF) / 255.0,
                  blue: CGFloat((rgba >> 8) & 0xFF) / 255.0,
                  alpha: CGFloat((rgba >> 0) & 0xFF) / 255.0)
    }

    /// Initializes a CGColor with an integer representing the red, green and blue channels.
    ///
    /// - Parameter argb: Integer with 8 bits per channels and red, green, blue channels order.
    /// - Returns: Initialized CGColor with alpha set to 1.
    public static func `init`(rgb: Int) -> CGColor {
        return CGColor.init(red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
                            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
                            blue: CGFloat((rgb >> 0) & 0xFF) / 255.0,
                            alpha: 1)
    }

    /// Red color.
    public static var red: CGColor {
        return CGColor(red: 1, green: 0, blue: 0, alpha: 1)
    }

    /// Green color.
    public static var green: CGColor {
        return CGColor(red: 0, green: 1, blue: 0, alpha: 1)
    }

    /// Blue color.
    public static var blue: CGColor {
        return CGColor(red: 0, green: 0, blue: 1, alpha: 1)
    }

    /// Gray color.
    public static var gray: CGColor {
        return CGColor(gray: 0.5, alpha: 1)
    }
}

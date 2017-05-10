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
}

//
//  CGColor.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 26/4/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

#if canImport(CoreGraphics)
import Foundation
import CoreGraphics

#if canImport(FoundationKitMac)
import FoundationKitMac
#else
import FoundationKit
#endif

#if !os(macOS) && canImport(UIKit)
import UIKit
#endif

extension CGColor {
    public static let defaultAlphaValue: CGFloat = 1.0
    
    #if !os(macOS) && canImport(UIKit)
    public static func cgColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = defaultAlphaValue) -> CGColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
    }
    
    public static func cgColor(gray: CGFloat, alpha: CGFloat = defaultAlphaValue) -> CGColor {
        return UIColor(white: gray, alpha: alpha).cgColor
    }
    #else
    public static func cgColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = defaultAlphaValue) -> CGColor {
        return CGColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public static func cgColor(gray: CGFloat, alpha: CGFloat = defaultAlphaValue) -> CGColor {
        return CGColor.init(gray: gray, alpha: alpha)
    }
    #endif
    
    /// Initializes a CGColor with an integer representing the alpha, red, green and blue channels.
    ///
    /// - Parameter argb: Integer with 8 bits per channels and alpha, red, green, blue channels order.
    /// - Returns: Initialized CGColor.
    private static func cgColor(argb: UInt32) -> CGColor? {
        guard argb >= 0 && argb <= 0xFFFFFFFF as UInt32 else {
            return nil
        }
        
        return CGColor.cgColor(
            red: CGFloat((argb >> 16) & 0xFF) / 255.0,
            green: CGFloat((argb >> 8) & 0xFF) / 255.0,
            blue: CGFloat((argb >> 0) & 0xFF) / 255.0,
            alpha: CGFloat((argb >> 24) & 0xFF) / 255.0)
    }
    
    /// Initializes a CGColor with an integer representing the red, green, blue and alpha channels.
    ///
    /// - Parameter argb: Integer with 8 bits per channels and red, green, blue, alpha channels order.
    /// - Returns: Initialized CGColor.
    private static func cgColor(rgba: UInt32) -> CGColor? {
        guard rgba >= 0 && rgba <= 0xFFFFFFFF as UInt32 else {
            return nil
        }
        
        return CGColor.cgColor(
            red: CGFloat((rgba >> 24) & 0xFF) / 255.0,
            green: CGFloat((rgba >> 16) & 0xFF) / 255.0,
            blue: CGFloat((rgba >> 8) & 0xFF) / 255.0,
            alpha: CGFloat((rgba >> 0) & 0xFF) / 255.0)
    }
    
    /// Initializes a CGColor with an integer representing the red, green and blue channels.
    ///
    /// - Parameter argb: Integer with 8 bits per channels and red, green, blue channels order.
    /// - Returns: Initialized CGColor with alpha set to 1.
    private static func cgColor(rgb: Int) -> CGColor? {
        guard rgb >= 0 && rgb <= 0xFFFFFF else {
            return nil
        }
        
        return CGColor.cgColor(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat((rgb >> 0) & 0xFF) / 255.0)
    }
    
    /// Initializes a CGColor with an RGB hexadecimal representation.
    ///
    /// - Parameter hexARGB: ARGB hexadecimal representation, `#FF000000` or `FF000000`.
    /// - Returns: Initialized CGColor.
    public static func cgColor(hexARGB: String) -> CGColor? {
        guard let colorInteger = hexARGB.hexadecimalColorInteger else {
            return nil
        }
        
        return CGColor.cgColor(argb: UInt32(colorInteger))
    }
    
    /// Initializes a CGColor with an RGBA hexadecimal representation.
    ///
    /// - Parameter hexRGBA: RGBA hexadecimal representation, `#000000FF` or `000000FF`.
    /// - Returns: Initialized CGColor.
    public static func cgColor(hexRGBA: String) -> CGColor? {
        guard let colorInteger = hexRGBA.hexadecimalColorInteger else {
            return nil
        }
        
        return CGColor.cgColor(rgba: UInt32(colorInteger))
    }
    
    /// Initializes a CGColor with an RGB hexadecimal representation.
    ///
    /// - Parameter hexRGB: RGB hexadecimal representation, `#FFFFFF` or `FFFFFF`.
    /// - Returns: Initialized CGColor with alpha set to 1.
    public static func cgColor(hexRGB: String) -> CGColor? {
        guard let colorInteger = hexRGB.hexadecimalColorInteger else {
            return nil
        }
        
        return CGColor.cgColor(rgb: colorInteger)
    }
    
    public static func cgColorWithValidation(hexRGB: String) throws -> CGColor {
        guard let cgColor = CGColor.cgColor(hexRGB: hexRGB) else {
            throw NSError(description: "Invalid input RGB hex color value “\(hexRGB)”. Valid input should be formatted with a pound symbol followed by six hexadecimal digits, for example “#FFFFFF”.")
        }
        
        return cgColor
    }
    
    /// Red color.
    public static var red: CGColor {
        return CGColor.cgColor(red: 1.0, green: 0.0, blue: 0.0)
    }
    
    /// Green color.
    public static var green: CGColor {
        return CGColor.cgColor(red: 0.0, green: 1.0, blue: 0.0)
    }
    
    /// Blue color.
    public static var blue: CGColor {
        return CGColor.cgColor(red: 0.0, green: 0.0, blue: 1.0)
    }
    
    /// Gray color.
    public static var gray: CGColor {
        return CGColor.cgColor(red: 0.5, green: 0.5, blue: 0.5)
    }
    
    #if !os(macOS)
    /// Black color.
    public static var black: CGColor {
        return CGColor.cgColor(red: 0.0, green: 0.0, blue: 0.0)
    }
    
    /// White color.
    public static var white: CGColor {
        return CGColor.cgColor(red: 1.0, green: 1.0, blue: 1.0)
    }
    #endif
}

extension CGColor {
    public static func cgColor(temperature: Measurement<UnitTemperature>) -> CGColor {
        let kelvin = temperature.converted(to: .kelvin).value
        
        var red: Float = 0.0
        var green: Float = 0.0
        var blue: Float = 0.0

        if kelvin <= 6600 {
            red = 1.0
        } else {
            red = Float(1.292936186062745) * powf(Float(kelvin) / Float(100.0) - Float(60.0), Float(-0.1332047592))
        }

        if kelvin <= 6600 {
            green = Float(0.39008157876902) * logf(Float(kelvin) / Float(100.0)) - Float(0.631841443788627)
        } else {
            green = Float(1.129890860895294) * powf(Float(kelvin) / Float(100.0) - Float(60.0), Float(-0.0755148492))
        }

        if kelvin >= 6600 {
            blue = 1.0
        } else {
            if kelvin <= 1900 {
                blue = 0.0
            } else {
                blue = Float(0.543206789110196) * logf(Float(kelvin) / Float(100.0) - Float(10.0)) - Float(1.19625408914)
            }
        }

        if red < 0.0 {
            red = 0.0
        } else if red > 1.0 {
            red = 1.0
        }
        if green < 0.0 {
            green = 0.0
        } else if green > 1.0 {
            green = 1.0
        }
        if blue < 0.0 {
            blue = 0.0
        } else if blue > 1.0 {
            blue = 1.0
        }

        return CGColor.cgColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue))
    }
}

extension CGColor {
    enum Space {
        static let sRGBIdentifiers: [CFString] = {
            return [CGColorSpace.sRGB, "kCGColorSpaceGenericRGB" as CFString]
        }()
        
        static let sRGB: CGColorSpace = {
            return CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
        }()
    }
}

extension CGColor {    
    public var rgbColor: CGColor {
        let cgColor: CGColor

        if #available(macOS 10.11, iOS 10, tvOS 10, *),
           !CGColor.Space.sRGBIdentifiers.contains(self.colorSpace?.name ?? "" as CFString) {
            cgColor = self.converted(
                to: CGColor.Space.sRGB, intent: .defaultIntent, options: nil) ?? CGColor.black
        }
        else {
            cgColor = self
        }
        
        return cgColor
    }
}

extension CGColor {
    public var redFraction: CGFloat {
        return self.rgbColor.components![0]
    }
    
    public var greenFraction: CGFloat {
        return self.rgbColor.components![1]
    }
    
    public var blueFraction: CGFloat {
        return self.rgbColor.components![2]
    }
    
    public var red: Int {
        return Int(self.redFraction * 255)
    }
    
    public var green: Int {
        return Int(self.greenFraction * 255)
    }
    
    public var blue: Int {
        return Int(self.blueFraction * 255)
    }
    
    public var hexRGB: String {
        var hexRGB = "#"
        let cgColor = self.rgbColor
        
        for colorComponent in [cgColor.red, cgColor.green, cgColor.blue] {
            hexRGB += Data([UInt8(colorComponent)]).hexString
        }
        
        return hexRGB
    }
}

@available(macOS 10.11, *)
extension CGColor {
    public var isLight: Bool {
        return self.brightness >= 0.5
    }
    
    public var isDark: Bool {
        return self.brightness < 0.5
    }
    
    private var brightness: CGFloat {
        guard let components = self.rgbColor.components, components.count >= 3 else {
            return 0
        }
        
        return CGFloat(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
    }
}

extension String {
    internal var hexadecimalColorInteger: Int? {
        let hexadecimalColorString = self.hasPrefix("#") ? String(
            self.suffix(from: self.index(self.startIndex, offsetBy: 1))) : self
        
        return Int(hexadecimalColorString, radix: 16)
    }
}
#endif

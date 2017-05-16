//
//  CGImage.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 26/4/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGImage {

    /// Cropping mode.
    ///
    /// - fill: Fill the given frame with the image.
    /// - fit: Fit the image in the given frame.
    public enum CroppingMode {
        case fill
        case fit
    }

    /// Initializes a CGImage with a given url and a cropping ratio.
    ///
    /// - Parameters:
    ///   - url: URL of the image.
    ///   - croppingRatio: Cropping ratio for the resulting image.
    /// - Returns: Returns a CGImage filled with the input image with the specified ratio.
    public static func `init`(url: URL, ratio: CGRatio, croppingMode: CroppingMode = .fill) -> CGImage? {

        if !FileManager.default.isReadableFile(atPath: url.path) {
            return nil
        }

        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }

        guard let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            return nil
        }

        return image.cropping(ratio: ratio, mode: croppingMode)
    }

    /// The ratio between the width and the height of the image.
    public var ratio: CGRatio {
        return CGFloat(self.width) / CGFloat(self.height)
    }

    /// Crops the image with the given ratio.
    ///
    /// - Parameters:
    ///   - ratio: The ratio of the cropped image.
    ///   - mode: Mode of the cropping.
    /// - Returns: Cropped image.
    public func cropping(ratio: CGRatio, mode: CroppingMode) -> CGImage? {
        if (self.ratio > ratio) != (mode == .fit) {
            let width = Int(CGFloat(self.height) * ratio)
            return self.cropping(to: CGRect(x: self.width / 2 - width / 2, y: 0, width: width, height: self.height))
        }
        else {
            let height = Int(CGFloat(self.width) / ratio)
            return self.cropping(to: CGRect(x: 0, y: self.height / 2 - height / 2, width: self.width, height: height))
        }
    }

    /// Writes image in a destiantion with the specified format.
    ///
    /// - Parameters:
    ///   - url: Destiantion URL.
    ///   - format: Destination format. JPEG by default.
    public func write(to url: URL, format: CFString = kUTTypeJPEG) {

        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, format, 1, nil) else {
            return
        }

        CGImageDestinationAddImage(destination, self, nil)
        CGImageDestinationFinalize(destination)
    }
}

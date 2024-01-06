//
//  CGImage.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 26/4/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

#if canImport(CoreGraphics)
import Foundation
import CoreGraphics
import ImageIO

#if canImport(FoundationKit)
import FoundationKit
#else
import FoundationKitMac
#endif

#if canImport(MobileCoreServices)
import MobileCoreServices
#elseif canImport(CoreServices)
import CoreServices
#endif

#if canImport(PDFKit)
import PDFKit
#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import Cocoa
import Quartz
#endif
#endif

extension CGImage {
    /// Cropping mode.
    ///
    /// - fill: Fill the given frame with the image.
    /// - fit: Fit the image in the given frame.
    public enum CroppingMode {
        case fill
        case fit
    }
}

extension CGImage {
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
}

extension CGImage {
    public func cgContextForImage(data: UnsafeMutableRawPointer? = nil, size: CGSize? = nil, width: Int? = nil, height: Int? = nil, bitsPerComponent: Int? = nil, bytesPerRow: Int? = nil, space: CGColorSpace? = nil, bitmapInfo: UInt32? = nil) -> CGContext? {
        return CGContext.cgContext(data: nil, width: width ?? self.width, height: height ?? self.height, bitsPerComponent: bitsPerComponent ?? self.bitsPerComponent, bytesPerRow: bytesPerRow, space: space ?? self.colorSpace, bitmapInfo: bitmapInfo)
    }
    
    public func cgContextForImage(data: UnsafeMutableRawPointer? = nil, width: CGFloat, height: CGFloat, bitsPerComponent: Int? = nil, bytesPerRow: Int? = nil, space: CGColorSpace? = nil, bitmapInfo: UInt32? = nil) -> CGContext? {
        return self.cgContextForImage(data: data, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: space, bitmapInfo: bitmapInfo)
    }
    
    public func cgContextForImage(data: UnsafeMutableRawPointer? = nil, size: CGSize, bitsPerComponent: Int? = nil, bytesPerRow: Int? = nil, space: CGColorSpace? = nil, bitmapInfo: UInt32? = nil) -> CGContext? {
        return self.cgContextForImage(data: data, width: size.width, height: size.height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: space, bitmapInfo: bitmapInfo)
    }
}

extension CGImage {
    public func resized(to size: CGSize) -> CGImage? {
        guard let context = self.cgContextForImage(size: size) else {
            return nil
        }
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: .zero, y: .zero, width: context.width, height: context.height))
        return context.makeImage()
    }

    public func resized(height: CGFloat) -> CGImage? {
        let sizeFactor = height / CGFloat(self.height)
        let newSize = CGSize(width: self.width, height: self.height).scaled(by: sizeFactor)
        return self.resized(to: newSize)
    }

    public func resized(width: CGFloat) -> CGImage? {
        let sizeFactor = width / CGFloat(self.width)
        let newSize = CGSize(width: self.width, height: self.height).scaled(by: sizeFactor)
        return self.resized(to: newSize)
    }
}

extension CGImage {
    public func resized(to targetSize: CGSize, mode: CroppingMode) -> CGImage? {
        var width = targetSize.width
        var height = targetSize.height
        let sourceSize = CGSize(width: self.width, height: self.height)
        
        switch mode {
        case .fill:
            let targetLength  = max(targetSize.height, targetSize.width)
            let sourceLength = min(sourceSize.height, sourceSize.width)
            let fillScale = targetLength / sourceLength
            width = sourceSize.width * fillScale
            height = sourceSize.height * fillScale
        case .fit:
            let aspectRatio = sourceSize.ratio
            if (targetSize.width / aspectRatio) <= targetSize.height {
                width = targetSize.width
                height = targetSize.width / aspectRatio
            } else {
                height = targetSize.height
                width = targetSize.height * aspectRatio
            }
        }
        
        let x = (targetSize.width - width) / 2.0
        let y = (targetSize.height - height) / 2.0

        guard let context = self.cgContextForImage(size: targetSize) else {
            return nil
        }
        context.interpolationQuality = .none
        context.draw(self, in: CGRect(x: x, y: y, width: width, height: height))

        return context.makeImage()
    }
}

extension CGImage {
    public func addingTransparentBorder(insets: CGRect.EdgeInsets) -> CGImage? {
        let newWidth = width + Int(insets.left + insets.right)
        let newHeight = height + Int(insets.top + insets.bottom)
        
        guard let context = self.cgContextForImage(width: newWidth, height: newHeight) else {
            return nil
        }
        context.draw(self, in: CGRect(x: Int(insets.left), y: Int(insets.top), width: width, height: height))
        return context.makeImage()
    }
}

extension CGImage {
    public func withBackgroundColor(_ color: CGColor = .white) -> CGImage? {
        guard let context = self.cgContextForImage() else {
            return nil
        }
        context.setFillColor(color)
        context.fill(CGRect(intWidth: width, intHeight: height))
        context.draw(self, in: CGRect(intWidth: width, intHeight: height))
        return context.makeImage()
    }
}

extension CGImage {
    public func withRoundedCorners(radius: CGFloat? = nil) -> CGImage? {
        let maxRadius = CGFloat(min(width, height)) / 2
        let cornerRadius = min(radius ?? maxRadius, maxRadius)
        guard let context = self.cgContextForImage() else {
            return nil
        }
        let rect = CGRect(intWidth: width, intHeight: height)
        let path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        context.addPath(path)
        context.clip()
        context.draw(self, in: rect)
        return context.makeImage()
    }
}

extension CGImage {
    var hasAlphaChannel: Bool {
        // Check if the image has an alpha component
        guard let alphaInfo = CGImageAlphaInfo(rawValue: alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue) else {
            return false
        }
        switch alphaInfo {
        case .none, .noneSkipLast, .noneSkipFirst:
            // These formats have no alpha channel
            return false
        default:
            break
        }
        return true
    }

    var hasAnyTransparency: Bool {
        guard self.hasAlphaChannel else {
            return false
        }

        let bytesPerPixel = 4
        let bitsPerComponent = 8
        let bytesPerRow = bytesPerPixel * width
        var rawData = [UInt8](repeating: 0, count: height * bytesPerRow)
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        guard let context = self.cgContextForImage(data: &rawData, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, bitmapInfo: bitmapInfo) else {
            return false
        }
        
        context.draw(self, in: CGRect(intWidth: width, intHeight: height))
        for y in 0..<height {
            for x in 0..<width {
                let byteIndex = (bytesPerRow * y) + x * bytesPerPixel
                let alpha = rawData[byteIndex + 3] // Alpha component is the last byte in RGBA
                if alpha < 255 {
                    return true
                }
            }
        }
        return false
    }
}

extension CGImage: CGSizeProvider {
    /// The size of the image.
    public var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
}

extension CGImage: CGRatioProvider {
    /// The ratio between the width and the height of the image.
    public var ratio: CGRatio {
        return CGFloat(self.width) / CGFloat(self.height)
    }
}

extension CGImage: CGAreaProvider {
    /// The ratio between the width and the height of the image.
    public var area: CGFloat {
        return CGFloat(self.width) * CGFloat(self.height)
    }
}

extension CGImage {
    /// Initializes a CGImage with a given URL.
    ///
    /// - Parameters:
    ///   - url: URL of the image.
    /// - Returns: Returns a CGImage filled with the input image.
    public static func cgImage(url: URL) -> CGImage? {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            return nil
        }
        
        return image
    }
    
    /// Load a CGImage from an image URL.
    /// - Parameter url: URL of the image.
    /// - Returns: Loaded image.
    public static func loadImage(at url: URL) throws -> CGImage {
        guard let image = self.cgImage(url: url) else {
            throw NSError(description: "No image could be loaded from “\(url.path)”.")
        }
        return image
    }
    
    /// Initializes a CGImage with a given URL and a cropping ratio.
    ///
    /// - Parameters:
    ///   - url: URL of the image.
    ///   - croppingRatio: Cropping ratio for the resulting image.
    /// - Returns: Returns a CGImage filled with the input image with the specified ratio.
    public static func cgImage(url: URL, ratio: CGRatio, croppingMode: CroppingMode = .fill) -> CGImage? {
        guard let image = CGImage.cgImage(url: url) else {
            return nil
        }
        
        return image.cropping(ratio: ratio, mode: croppingMode)
    }
}
extension CGImage {
    public static func cgImage(data: Data) -> CGImage? {
        guard let dataProvider = CGDataProvider(data: data as CFData) else { return nil }
        guard let imageSource = CGImageSourceCreateWithDataProvider(dataProvider, [:] as CFDictionary) else { return nil }
        return CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
    }

    public static func loadImage(from data: Data) throws -> CGImage {
        guard let image = self.cgImage(data: data) else {
            throw NSError(description: "No image could be loaded from data.")
        }
        return image
    }
}

extension CGImage {
    /// Load images in PDF document or image file.
    /// - Parameter url: URL of document of image.
    /// - Returns: Loaded images.
    public static func loadImages(at url: URL) throws -> [CGImage] {
        var outputImages: [CGImage] = []
        
#if canImport(PDFKit)
        if let pdfDocument = PDFDocument(url: url) {
            for i in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: i) {
                    let pageRect = page.bounds(for: .mediaBox).scaled(by: 6)
                    let pageImage = page.thumbnail(of: pageRect.size, for: .mediaBox)
                    if let image = pageImage.cgImage {
                        outputImages.append(image)
                    }
                }
            }
        }
#endif
        
        if outputImages.isEmpty {
            if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
                let imageSourceCount = CGImageSourceGetCount(imageSource)
                for i in 0..<imageSourceCount {
                    if let image = CGImageSourceCreateImageAtIndex(imageSource, i, nil) {
                        outputImages.append(image)
                    }
                }
            }
        }
        
        if outputImages.isEmpty {
            throw NSError(description: "No images could be loaded from “\(url.path)”.")
        }
        return outputImages
    }
}

extension CGImage {
    /// Image file format.
    public enum OutputFormat {
        case jpeg
        case png
        case bmp
        
        var utiType: CFString {
            switch self {
            case .jpeg:
                return kUTTypeJPEG
            case .png:
                return kUTTypePNG
            case .bmp:
                return kUTTypeBMP
            }
        }
        
        public var pathExtension: String {
            switch self {
            case .jpeg:
                return "jpg"
            case .png:
                return "png"
            case .bmp:
                return "bmp"
            }
        }
    }
    
    /// Writes the image in a destination with the specified format.
    ///
    /// - Parameters:
    ///   - url: Destination URL.
    ///   - format: Destination format. JPEG by default.
    public func write(to url: URL, format: OutputFormat = .jpeg) throws {
        try self.write(to: url, format: format.utiType)
    }
    
    /// Writes the image in a destination with the specified format.
    ///
    /// - Parameters:
    ///   - url: Destination URL.
    ///   - format: Destination UTI type.
    public func write(to url: URL, format: CFString) throws {
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, format, 1, nil) else {
            throw CGError.OutputError.destinationNotAvailable
        }
        
        CGImageDestinationAddImage(destination, self, nil)
        
        guard CGImageDestinationFinalize(destination) else {
            throw CGError.OutputError.errorWrittingOutput
        }
    }
    
    /// Writes the image to a temporary location.
    ///
    /// Note: Uses the FoundationKit `FileManger.autocleanedTemporaryDirectory` to temporary store the generated image.
    ///
    /// - Parameters:
    ///   - format: Destination format. JPEG by default.
    public func temporaryFile(format: OutputFormat = .jpeg) throws -> URL {
        let imageUUID = UUID()
        let temporaryImageURL = FileManager.default.autocleanedTemporaryDirectory
            .appendingPathComponent(imageUUID.uuidString)
            .appendingPathExtension(format.pathExtension)
        try self.write(to: temporaryImageURL, format: format)
        
        return temporaryImageURL
    }
        
    @available(iOSApplicationExtension, unavailable)
    @available(tvOSApplicationExtension, unavailable)
    @available(watchOSApplicationExtension, unavailable)
    @available(macCatalystApplicationExtension, unavailable)
    /// Renders the image to a temporary location and and opens it.
    ///
    /// - Parameters:
    ///   - format: Destination format. JPEG by default.
    public func open(format: OutputFormat = .jpeg) throws {
        let temporaryFile = try self.temporaryFile()
        try temporaryFile.open()
    }
}

extension CGImage {
    public func pngData() -> Data? {
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, kUTTypePNG, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return data as Data
    }
    
    public func temporaryPNG() throws -> URL {
        return try self.temporaryFile(format: .png)
    }
}

#if os(macOS)
extension NSImage {
    public var cgImage: CGImage? {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}
#endif
#endif

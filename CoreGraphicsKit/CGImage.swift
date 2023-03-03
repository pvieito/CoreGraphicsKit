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


#if os(macOS)
extension NSImage {
    var cgImage: CGImage? {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}
#endif
#endif

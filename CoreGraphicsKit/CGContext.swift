//
//  CGContext.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 18/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGContext {

    /// Draws the context in a temporary image file.
    ///
    /// Note: Use the `CGCache` `cleanCache()` method to clean the generated images from the temporary directory.
    ///
    /// - Parameters:
    ///   - format: Destination format. JPEG by default.
    public func temporaryImageFile(format: CGImage.OuputFormat = .jpeg) throws -> URL {

        guard let image = self.makeImage() else {
            throw CGError.OutputError.imageNotGenerated
        }

        return try image.temporaryFile(format: format)
    }
}

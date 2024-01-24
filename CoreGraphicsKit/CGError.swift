//
//  CGError.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 9/9/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

#if canImport(CoreGraphics)
import Foundation
import CoreGraphics

extension CGError {
    public enum OutputError: LocalizedError {
        case imageNotGenerated
        case destinationNotAvailable
        case errorWritingOutput

        public var errorDescription: String? {
            switch self {
            case .imageNotGenerated:
                return "The image of the CGContext did not render successfully."
            case .destinationNotAvailable:
                return "The image destination is not available."
            case .errorWritingOutput:
                return "Error writing output image to the destination."
            }
        }
    }
}
#endif

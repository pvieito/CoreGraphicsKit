//
//  CGError.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 9/9/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGError {
    
    public enum OutputError: LocalizedError {
        case imageNotGenerated
        case destinationTypeNotSupported
        case errorWrittingOutput

        public var errorDescription: String? {
            
            switch self {
            case .imageNotGenerated:
                return "The image of the CGContext did not render successfully."
            case .destinationTypeNotSupported:
                return "The image destination format is not supported."
            case .errorWrittingOutput:
                return "Error writting output image to the destination."
            }
        }
    }
}

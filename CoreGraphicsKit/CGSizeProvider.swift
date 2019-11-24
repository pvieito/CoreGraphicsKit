//
//  CGSizeProvider.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 10/6/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

#if canImport(Darwin)
import CoreGraphics
#endif

public protocol CGSizeProvider {
    var size: CGSize { get }
}

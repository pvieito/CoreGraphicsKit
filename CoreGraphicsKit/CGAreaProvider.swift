//
//  CGAreaProvider.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 29/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

#if canImport(CoreGraphics)
import CoreGraphics
#endif

public protocol CGAreaProvider {
    var area: CGFloat { get }
}

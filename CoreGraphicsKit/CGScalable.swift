//
//  CGScalable.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 10/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

public protocol CGScalable {
    func scaled(by scale: CGFloat) -> Self
}

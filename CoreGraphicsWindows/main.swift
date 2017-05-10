//
//  main.swift
//  WindowTool
//  Tool that shows information of each window drawn by Core Graphics.
//
//  Created by Pedro José Pereira Vieito on 7/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreGraphicsKit
import LoggerKit
import Cocoa

Logger.logMode = .commandLine

let screenRect = NSScreen.main()!.visibleFrame
let windowRect = screenRect.scaled(by: 0.5)
let context = CGContext(data: nil, width: Int(screenRect.width) * 3, height: Int(screenRect.height) * 3, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
let window = NSWindow(contentRect: windowRect, styleMask: NSWindowStyleMask.titled, backing: NSBackingStoreType.buffered, defer: false)

let imageView = NSImageView(frame: windowRect)
window.contentView = imageView
window.makeKeyAndOrderFront(NSApp)
window.makeKey()

DispatchQueue.main.async {
    //let context = window.graphicsContext?.cgContext
    context?.translateBy(x: 1280, y: 1600)
    context?.scaleBy(x: 1, y: -1)

    let textFont = NSFont.systemFont(ofSize: 100, weight: 0.03)
    let textAttributes: [String : Any] = [NSForegroundColorAttributeName: NSColor.black, NSFontAttributeName: textFont]

    for window in CGWindowInformation.systemWindows {
        Logger.log(important: "\(window.ownerName) (PID: \(window.ownerPID))")
        Logger.log(info: "ID: \(window.id)")
        Logger.log(info: "Name: \(window.name == "" ? "--" : window.name)")
        Logger.log(info: "Bounds: \(window.bounds)")

        context?.stroke(window.bounds, width: 2)

        context?.setFillColor(CGColor.black)
        window.name.draw(at: window.bounds.origin, withAttributes: textAttributes)
    }
    
    let image = context?.makeImage()

    imageView.image = NSImage(cgImage: image!, size: windowRect.size)
}

dispatchMain()


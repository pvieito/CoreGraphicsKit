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
import CommandLineKit


let matchOption = StringOption(shortFlag: "m", longFlag: "match", helpMessage: "Name of process to inspect.")
let showOption = BoolOption(shortFlag: "s", longFlag: "show", helpMessage: "Shows a plot of the windows.")
let verboseOption = BoolOption(shortFlag: "v", longFlag: "verbose", helpMessage: "Verbose Mode.")
let helpOption = BoolOption(shortFlag: "h", longFlag: "help", helpMessage: "Prints a help message.")

let cli = CommandLineKit.CommandLine()
cli.addOptions(matchOption, showOption, verboseOption, helpOption)

do {
    try cli.parse()
}
catch {
    cli.printUsage(error)
    exit(-1)
}

if helpOption.value {
    cli.printUsage()
    exit(0)
}

Logger.logMode = .commandLine
Logger.logLevel = verboseOption.value ? .debug : .info

guard let screenRect = NSScreen.main()?.frame, let screenScale = NSScreen.main()?.backingScaleFactor, let context = CGContext(data: nil, width: Int(screenRect.width) * 3, height: Int(screenRect.height) * 3, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
    Logger.log(error: "Error loading Graphic Context.")
    exit(-1)
}

Logger.log(info: "Screen resolution: \(screenRect.size) (\(Int(screenScale))x)")

context.translateBy(x: screenRect.width, y: 2 * screenRect.height)
context.scaleBy(x: 1, y: -1)

context.setStrokeColor(CGColor.blue)
context.stroke(screenRect, width: 3.0)

Logger.log(debug: "Listing Core Graphics Windows...")

var inspectedApplications = CGTWorkspace.shared.systemApplications

if let matchPattern = matchOption.value {
    inspectedApplications = inspectedApplications.filter({ $0.description.lowercased().contains(matchPattern.lowercased()) })
}

inspectedApplications.sort(by: { $0.description < $1.description })

guard !inspectedApplications.isEmpty else {
    Logger.log(error: "Match query does not match any Core Graphics window.")
    exit(0)
}

var matchedWindows: [CGTWindow] = []

for inspectedApplication in inspectedApplications {

    Logger.log(important: "\(inspectedApplication.localizedName) (\(inspectedApplication.processIdentifier))")

    if inspectedApplication.runningApplication == nil {
        Logger.log(warning: "This process is not an application.")
    }

    if let bundleIdentifier = inspectedApplication.runningApplication?.bundleIdentifier {
        Logger.log(info: "Bundle Identifier: \(bundleIdentifier)")
    }

    if let bundleURL = inspectedApplication.runningApplication?.bundleURL {
        Logger.log(info: "Bundle: \(bundleURL.path)")
    }

    let windows = inspectedApplication.windows.sorted(by: { $0.bounds.area > $1.bounds.area })

    for window in windows {
        Logger.log(success: "Window ID: \(window.id)")

        if window.name != "" {
            Logger.log(info: "Name: \(window.name)")
        }

        Logger.log(info: "Bounds: \(window.bounds)")
    }

    matchedWindows.append(contentsOf: windows)
}

if showOption.value {
    Logger.log(debug: "Showing windows plot...")

    for window in matchedWindows.sorted(by: { $0.bounds.area > $1.bounds.area }) {

        if let image = CGWindowListCreateImage(window.bounds, [.optionIncludingWindow], window.id, [.bestResolution]) {
            let cocoaImage = NSImage(cgImage: image, size: .zero)
            let graphicsContext = NSGraphicsContext(cgContext: context, flipped: true)
            NSGraphicsContext.setCurrent(graphicsContext)
            cocoaImage.draw(in: window.bounds)
        }

        context.setStrokeColor(CGColor.red)
        context.stroke(window.bounds, width: 2.0)
    }

    if let image = context.makeImage() {
        do {
            let imageURL = try image.temporaryFile()
            NSWorkspace.shared().open(imageURL)
        }
        catch {
            Logger.log(error: error)
        }
    }
    else {
        Logger.log(error: "Context Image not available.")
    }
}

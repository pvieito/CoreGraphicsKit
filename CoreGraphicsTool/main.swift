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

let screenRect = NSScreen.main()!.frame
let screenScale = NSScreen.main()!.backingScaleFactor

Logger.log(info: "Screen resolution: \(screenRect.size) (\(Int(screenScale))x)")

let context = CGContext(data: nil, width: Int(screenRect.width) * 3, height: Int(screenRect.height) * 3, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

context?.translateBy(x: screenRect.width, y: 2 * screenRect.height)
context?.scaleBy(x: 1, y: -1)

context?.setStrokeColor(CGColor.blue)
context?.stroke(screenRect, width: 3.0)

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

    for window in inspectedApplication.windows {
        Logger.log(success: "Window ID: \(window.id)")

        if window.name != "" {
            Logger.log(info: "Name: \(window.name)")
        }

        Logger.log(info: "Bounds: \(window.bounds)")

        context?.setStrokeColor(CGColor.red)
        context?.stroke(window.bounds, width: 2.0)
    }
}

if showOption.value {
    Logger.log(debug: "Showing windows plot...")

    let image = context?.makeImage()
    let temporaryDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("com.pvieito.CoreGraphicsTool")
    try? FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true, attributes: nil)
    let imageURL = temporaryDirectory.appendingPathComponent("CGWindows").appendingPathExtension("jpg")
    Logger.log(debug: "Ouput path: \(imageURL.path)")
    image?.write(to: imageURL)

    NSWorkspace.shared().open(imageURL)
}
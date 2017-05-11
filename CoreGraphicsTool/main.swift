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


let matchOption = MultiStringOption(shortFlag: "m", longFlag: "match", helpMessage: "Name of process to inspect.")
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

var selectedWindows = CGWindowInformation.systemWindows

if let matchPatterns = matchOption.value {
    selectedWindows = selectedWindows.filter({ matchPatterns.contains($0.ownerName) })
}

if !selectedWindows.isEmpty {

    for window in selectedWindows {
        Logger.log(important: "\(window.ownerName) (PID: \(window.ownerPID))")
        Logger.log(info: "ID: \(window.id)")
        Logger.log(info: "Name: \(window.name == "" ? "--" : window.name)")
        Logger.log(info: "Bounds: \(window.bounds)")

        context?.setStrokeColor(CGColor.red)
        context?.stroke(window.bounds, width: 2.0)
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
}
else {
    Logger.log(error: "Match query does not match any Core Graphics window.")
}

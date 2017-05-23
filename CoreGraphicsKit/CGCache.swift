//
//  CGCache.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 18/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

class CGCache {

    private static var isClean = false

    private static var temporaryDirectoryURL: URL {
        let processName = Bundle.main.bundleIdentifier ?? ProcessInfo().processName

        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("CoreGraphicsKit").appendingPathComponent(processName)

        return temporaryDirectoryURL
    }

    private static func cleanCache() throws {
        if FileManager.default.fileExists(atPath: temporaryDirectoryURL.path) {
            try FileManager.default.removeItem(at: temporaryDirectoryURL)
        }
    }

    static func generateTemporaryFileURL() throws -> URL {

        if !isClean {
            try cleanCache()
            isClean = true
        }

        try FileManager.default.createDirectory(at: temporaryDirectoryURL, withIntermediateDirectories: true, attributes: nil)

        let imageName = UUID().uuidString

        return temporaryDirectoryURL.appendingPathComponent(imageName)
    }
}

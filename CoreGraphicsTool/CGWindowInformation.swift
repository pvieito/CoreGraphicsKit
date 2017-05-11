//
//  CGWindowInformation.swift
//  WindowTool
//
//  Created by Pedro José Pereira Vieito on 7/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation

class CGWindowInformation: CustomStringConvertible {

    let ownerPID: pid_t
    let ownerName: String

    let id: Int
    let bounds: CGRect
    let name: String

    init?(info: [String: Any]) {

        guard let ownerPID = info[kCGWindowOwnerPID as String] as? pid_t else {
            return nil
        }

        guard let ownerName = info[kCGWindowOwnerName as String] as? String else {
            return nil
        }

        guard let id = info[kCGWindowNumber as String] as? Int else {
            return nil
        }

        guard let bounds = info[kCGWindowBounds as String] else {
            return nil
        }

        guard let boundsRect = CGRect(dictionaryRepresentation: bounds as! CFDictionary)  else {
            return nil
        }

        guard let name = info[kCGWindowName as String] as? String else {
            return nil
        }

        self.ownerPID = ownerPID
        self.ownerName = ownerName
        self.id = id
        self.bounds = boundsRect
        self.name = name
    }

    var description: String {
        return "\(self.ownerName) (PID: \(self.ownerPID)) Window \(self.id): \(self.name == "" ? "--" : self.name) - \(self.bounds)"
    }

    static var systemWindows: [CGWindowInformation] {

        if let windows = CGWindowListCopyWindowInfo(CGWindowListOption.optionAll, kCGNullWindowID), let windowsDictionaries = windows as? [[String: Any]], let systemWindowsInfo = windowsDictionaries.map({ CGWindowInformation(info: $0) }).filter({ $0 != nil }) as? [CGWindowInformation] {
            return systemWindowsInfo
        }

        return []
    }
}

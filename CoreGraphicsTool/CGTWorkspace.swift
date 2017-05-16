//
//  CGTWorkspace.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 15/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Cocoa

class CGTWorkspace {

    static var shared = CGTWorkspace()

    var systemApplications: [CGTApplication] {

        var systemApplications: [CGTApplication] = []

        for window in systemWindows {
            if let index = systemApplications.index(where: { $0.processIdentifier == window.ownerPID }) {
                systemApplications[index].windows.append(window)
            }
            else {
                let application = CGTApplication(windows: window)
                systemApplications.append(application)
            }
        }

        return systemApplications
    }

    var systemWindows: [CGTWindow] {

        if let windows = CGWindowListCopyWindowInfo(CGWindowListOption.optionAll, kCGNullWindowID), let windowsDictionaries = windows as? [[String: Any]], let systemWindowsInfo = windowsDictionaries.map({ CGTWindow(info: $0) }).filter({ $0 != nil }) as? [CGTWindow] {
            return systemWindowsInfo
        }

        return []
    }
}

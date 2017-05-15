//
//  CGTApplication.swift
//  CoreGraphicsKit
//
//  Created by Pedro José Pereira Vieito on 7/5/17.
//  Copyright © 2017 Pedro José Pereira Vieito. All rights reserved.
//

import Foundation
import Cocoa

class CGTApplication {

    let runningApplication: NSRunningApplication?
    
    var windows: [CGTWindow] = []

    var localizedName: String {
        return self.runningApplication?.localizedName ?? self.windows.first?.ownerName ?? "--"
    }

    var processIdentifier: pid_t {
        return self.runningApplication?.processIdentifier ?? self.windows.first?.ownerPID ?? -1
    }

    init(window: CGTWindow) {

        self.runningApplication = NSRunningApplication(processIdentifier: window.ownerPID)
        self.windows.append(window)
    }

    var description: String {
        return "\(self.localizedName): \(self.processIdentifier), \(self.runningApplication?.bundleIdentifier ?? "--"), \(self.runningApplication?.bundleURL?.path ?? "--"), \(self.windows.map({ $0.description }).joined(separator: ", "))"
    }
}

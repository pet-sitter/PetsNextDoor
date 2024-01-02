//
//  OSLog.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation
import os

extension Logger {
  
  private static var subsystem = Bundle.main.bundleIdentifier!
  
  static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
  
  static let statistics = Logger(subsystem: subsystem, category: "statistics")
  
  static let ui = Logger(subsystem: subsystem, category: "UI")
  
  static let network = Logger(subsystem: subsystem, category: "Network")
  
  static let `default` = Logger(subsystem: subsystem, category: "Default")
}

typealias PNDLogger = Logger

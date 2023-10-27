//
//  Updater.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/27.
//

import Foundation

protocol Updater {
  
  associatedtype Target: AnyObject
  associatedtype Adapter: PetsNextDoor.Adapter
  
  func prepare(target: Target, adapter: Adapter)
  
  func performUpdates(target: Target, adapter: Adapter, sectionData: [Section])
}

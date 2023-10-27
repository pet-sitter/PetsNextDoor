//
//  UITableViewUpdater.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/27.
//

import UIKit

final class UITableViewUpdater<TargetAdapter: UITableViewAdapter>: Updater {
  
  typealias Target = UITableView
  
  func prepare(target: UITableView, adapter: TargetAdapter) {
    target.delegate   = adapter
    target.dataSource = adapter
    target.reloadData()
  }
  
  func performUpdates(
    target: UITableView,
    adapter: TargetAdapter,
    sectionData: [Section]
  ) {
    adapter.sectionData = sectionData
    target.reloadData()
  }
}

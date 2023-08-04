//
//  TableViewAdapter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import UIKit
import Combine
import SnapKit

final class TableViewDataSourceProvider {
  
  private(set) var components: [any Component]
  
  var numberOfRowsInSection: Int { components.count }
  
  var numberOfSections: Int = 1
  
  init(components: [any Component]) {
    self.components = components
  }

  
}

final class TableViewAdapter: NSObject {
  
  private(set) var onRowTouch: PassthroughSubject<any CellItemModelType, Never> = .init()
  
  private(set) weak var tableView: UITableView!
  
  
  
  init(tableView: UITableView) {
    self.tableView = tableView
    super.init()
    configureTableView()
  }
  
  private func configureTableView() {
    
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension TableViewAdapter {
  
  func configureDataSource() {
    
  }

}

extension TableViewAdapter: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    return .init()
    //    let cell: UITableViewCell
    //
    //
    //
    //
    //
    //    return cell
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    0
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    0
  }
}

extension TableViewAdapter: UITableViewDelegate {

}



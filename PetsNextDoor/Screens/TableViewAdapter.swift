//
//  TableViewAdapter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import UIKit
import Combine
import SnapKit

final class TableViewAdapter: NSObject {
  
  private(set) weak var tableView: UITableView!
  
  private var components: [any Component] = []
  
  private var subscriptions = Set<AnyCancellable>()

  init(tableView: UITableView) {
    self.tableView  = tableView
    super.init()
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension TableViewAdapter {
  
  func observeDataSource(componentPublisher: Published<[any Component]>.Publisher) {
    componentPublisher
      .sink { [weak self] components in
        guard let self else { return }
        self.components = components
        tableView.reloadData()
      }
      .store(in: &subscriptions)
  }

  func reloadData() {
    tableView.reloadData()
  }
}

extension TableViewAdapter: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let component = components[safe: indexPath.row] else { return .init() }
    
    let cellIdentifier = "ContainerCell<\(type(of: component).identifier)>"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    
    if let cell = cell as? CellItemModelBindable {
      cell.bind(cellItemModel: component)
    }
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    components.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    components[safe: indexPath.row]?.height ?? 0.0

  }
}

extension TableViewAdapter: UITableViewDelegate {

}



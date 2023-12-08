//
//  UITableViewAdapter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/23.
//

import UIKit

class UITableViewAdapter: NSObject, Adapter {
  
  typealias Target = UITableView
  
  var sectionData: [Section]
  private(set) var target: Target

  private(set) var onSelection: ((ComponentSelectionInfo) -> Void)?
  
  init(
    data: [Section] = [],
    target: Target
  ) {
    self.sectionData      = data
    self.target  = target
  }

  func prepare() {
    target.delegate   = self
    target.dataSource = self
    target.reloadData()
  }
  
  func reloadData(withSectionData sectionData: [Section]) {
    self.sectionData = sectionData
    target.reloadData()
  }
}

//MARK: - Selection Actions

extension UITableViewAdapter {
  
  struct ComponentSelectionInfo {
    var tableView: UITableView
    var component: any Component
    var indexPath: IndexPath
  }
  
  @discardableResult
  func onSelection(_ onSelectionAction: @escaping ((ComponentSelectionInfo) -> Void)) -> Self {
    self.onSelection = onSelectionAction
    return self
  }
}


//MARK: - UITableViewDataSource

extension UITableViewAdapter: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    sectionData.count
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    components(inSection: section).count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    let component       = components(atIndexPath: indexPath)
    let reuseIdentifier = component.identifier
    let componentCell   = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? UITableViewCell & ComponentRenderable
    
    guard let cell = componentCell else {
      tableView.registerComponent(reuseIdentifier: reuseIdentifier)
      return self.tableView(tableView, cellForRowAt: indexPath)
    }
    
    cell.render(component: component)
    return cell
  }
}


//MARK: - UITableViewDelegate

extension UITableViewAdapter: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    let component = components(atIndexPath: indexPath)

    return component.contentHeight() ?? UITableView.automaticDimension
  }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    guard let onSelection else { return }
    
    let component     = components(atIndexPath: indexPath)
    let selectionInfo = ComponentSelectionInfo(tableView: tableView, component: component, indexPath: indexPath)
    
    onSelection(selectionInfo)
  }
}

//MARK: - ETC Methods

extension UITableView {
  
  func registerComponent(reuseIdentifier: String) {
    register(ComponentTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
  }
}

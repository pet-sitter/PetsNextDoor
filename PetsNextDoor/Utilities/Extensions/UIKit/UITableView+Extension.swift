//
//  UITableView+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/04.
//

import UIKit

extension UITableViewCell: IdentifierProvidable {}

extension UITableView {
  
  func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
    else { fatalError("Could not dequeue cell with identifier: \(T.identifier)") }
    return cell
  }
  
  func registerCell<T: UITableViewCell>(_: T.Type) {
    self.register(T.self, forCellReuseIdentifier: T.identifier)
  }
  
  var registeredClasses: [String: Any] {
    let dict = value(forKey: "_cellClassDict") as? [String: Any]
    return dict ?? [:]
  }
}

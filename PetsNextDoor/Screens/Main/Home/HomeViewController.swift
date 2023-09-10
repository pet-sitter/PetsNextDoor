//
//  HomeViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/27.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

final class HomeViewController: BaseViewController {
  
  private var tableView: UITableView!
  private var adapter: TableViewAdapter!
  
  typealias Feature = HomeFeature
  typealias State   = HomeFeature.State
  typealias Action  = HomeFeature.Action
  
  private let viewStore: ViewStoreOf<Feature>
  
  @Published var components: [any Component] = []
  
  init(store: some StoreOf<Feature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "용답동", style: .done, target: self, action: nil)
    
    
  }
  
  override func configureUI() {
    super.configureUI()
    
    tableView = BaseTableView()
    tableView.set {
      view.addSubview($0)
      $0.registerCell(ContainerCell<UrgentPostCardComponent>.self)
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    
    adapter = TableViewAdapter(tableView: tableView)
    adapter.observeDataSource(componentPublisher: $components)
    
    components = ComponentBuilder {
      
      for _ in (1..<10) {
        UrgentPostCardComponent(
          context: .init(
            postTitle: "돌봄 급히 구함",
            date: "2022-10-30",
            location: "반포동",
            cost: "시급 10,500원"))
      }
      

    }
  }
  
  
}

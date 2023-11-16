//
//  UrgentPostDetailViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/15.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

struct UrgentPostDetailFeature: Reducer {
  
  struct State: Equatable {
    
  }
  
  enum Action: Equatable {
    
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      return .none
    }
  }
}



final class UrgentPostDetailViewController: BaseViewController, RenderableViewProvidable {
  
  private var tableView: BaseTableView!
  
  private let viewStore: ViewStoreOf<UrgentPostDetailFeature>
  
  private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
  
  var renderableView: RenderableView {
    Section {
      EmptyComponent(height: 10)
    }
  }
  
  init(store: some StoreOf<UrgentPostDetailFeature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    renderer.render { renderableView }
  }
  
  override func configureUI() {
    super.configureUI()
    configureNavigationBarItems()
    
    hidesBottomBarWhenPushed = true
    
    tableView = BaseTableView()
    tableView.set {
      view.addSubview($0)
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
  }
  
  private func configureNavigationBarItems() {

    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(
        customView: UIImageView(image: UIImage(systemName: "gearshape"))
          .frame(width: 24, height: 24)
      )
    ]
  }
  
}

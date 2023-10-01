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
  
  private let districtNameNavigationBarView = DistrictNameView()
  
  init(store: some StoreOf<Feature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
   


  }
  
  
  
  override func configureUI() {
    super.configureUI()
    
    configureNavigationBarItems()
    
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
  
  private func configureNavigationBarItems() {
    
    navigationItem.leftBarButtonItems = [
      UIBarButtonItem(
        customView: UIImageView(image: UIImage(resource: R.image.icon_pin_nav_bar))
          .frame(width: 24, height: 24)
      ),
      UIBarButtonItem(customView: districtNameNavigationBarView)
    ]
    
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      customView:  UIButton(type: .system)
        .image(UIImage(resource: R.image.icon_pen))
        .frame(width: 24, height: 24)
        .tintColor(PND.Colors.commonBlack)
        .onTap { [weak self] in
          // 글쓰기
          print("✅ did tap post")
        }
    )
    
    
  }
  

  
}

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

final class HomeViewController: BaseViewController, RenderableViewProvidable {
  
  private var tableView: BaseTableView!
  
  typealias Feature = HomeFeature
  typealias State   = HomeFeature.State
  typealias Action  = HomeFeature.Action
  
  private let viewStore: ViewStoreOf<Feature>
  
  private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
  
  var renderableView: RenderableView {
    Section {
      SegmentControlComponent(
        viewModel: .init(segmentTitles: ["돌봄급구", "돌봄메이트"])
      )
      .onSegmentChange { index in

      }
      
      EmptyComponent(
        height: 20,
        backgroundColor: UIColor(hex: "#F9F9F9")
      )

      SelectCategoryComponent(viewModel: .init())
        .onCategoryChange { category in

        }
      

    }
    
    Section {
			For(each: viewStore.urgenPostCardCellViewModels) { cellVM in
        UrgentPostCardComponent(viewModel: cellVM)
          .onTouch { [weak self] _ in
            self?.viewStore.send(.didTapUrgentPost(cellVM))
          }
      }
    }
  }
  
  init(store: some StoreOf<Feature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewStore.send(.viewDidLoad)
    renderer.render { renderableView }
  }
  
  override func configureUI() {
    super.configureUI()
    configureNavigationBarItems()
    
    configureTopLeftTitle("")
    
    tableView = BaseTableView()
    tableView.set {
      view.addSubview($0)
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
  }
  
  private func configureNavigationBarItems() {
    
    navigationItem.leftBarButtonItems = [
      UIBarButtonItem(
        customView: UIImageView(image: UIImage(resource: R.image.icon_pin_nav_bar))
          .frame(width: 24, height: 24)
      ),
      UIBarButtonItem(customView: NavigationTitleBarView(
        viewModel: .init(
          titleString: "이웃집멍냥이네",
          isUnderlineViewHidden: false
        )
      ))
    ]
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      customView:  UIButton(type: .system)
        .image(UIImage(resource: R.image.icon_pen))
        .frame(width: 24, height: 24)
        .tintColor(PND.Colors.commonBlack)
        .onTap { [weak self] in
          self?.viewStore.send(.didTapWritePostIcon)
        }
    )
  }
}

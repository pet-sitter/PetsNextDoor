//
//  CommunityViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/27.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

final class CommunityViewController: BaseViewController, RenderableViewProvidable {
  
  private var tableView: BaseTableView!
  
  typealias Feature = CommunityFeature
  typealias State   = CommunityFeature.State
  typealias Action  = CommunityFeature.Action
  
  private let viewStore: ViewStoreOf<Feature>
  
  private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
  
  var renderableView: RenderableView {
    Section {
      SegmentControlComponent(
        viewModel: .init(segmentTitles: ["둘러보기", "내 모임"])
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


      ForEach(viewStore.meetingCardCellViewModels) { cellVM in
        MeetingCardComponent(viewModel: cellVM)
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
          titleString: "중곡동의 멍냥모임",             // TODO: 본인 동네로 치환
          isUnderlineViewHidden: true
        )
      ))
    ]
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      customView:  UIButton(type: .system)
        .image(UIImage(systemName: "plus"))
        .frame(width: 24, height: 24)
        .tintColor(PND.Colors.commonBlack)
        .onTap { [weak self] in
          
        }
    )
  }
}

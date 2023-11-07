//
//  SelectCareConditionsViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/03.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

final class SelectCareConditionsViewController: BaseViewController, RenderableViewProvidable {
  
  private var tableView: UITableView!
  private var bottomButton: BaseBottomButton!
  
  private lazy var renderer = Renderer(
    adapter: UITableViewAdapter(),
    updater: UITableViewUpdater(),
    target: tableView
  )
  
  var renderableView: RenderableView {
    Section {
      HeaderTitleComponent(
        viewModel: .init(
          title: "돌봄 조건",
          textAlignment: .left
        )
      )
      
      EmptyComponent(height: 20)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func configureUI() {
    super.configureUI()
    
    hidesBottomBarWhenPushed = true
    
    bottomButton = BaseBottomButton()
    bottomButton.set {
      view.addSubview($0)
      
      
      
//      $0.configure(viewModel: .init(isEnabled: false, buttonTitle: "다음 단계로"))
      $0.snp.makeConstraints {
        $0.bottom.equalToSuperview().inset(UIScreen.safeAreaBottomInset).inset(50)
        $0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
        $0.height.equalTo(BaseBottomButton.defaultHeight)
      }
    }
    
    tableView = BaseTableView()
    tableView.set {
      view.addSubview($0)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(bottomButton.snp.top)
      }
    }
  }
  
  private func bindState() {
  
    
  }
  
}

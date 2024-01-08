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
  
  private let viewStore: ViewStoreOf<SelectCareConditionFeature>
  
  private var tableView: UITableView!
  private var bottomButton: BaseBottomButton!
  
  private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
  
  var renderableView: RenderableView {
    Section {
      EmptyComponent(height: 24)
      HeaderTitleComponent(
        viewModel: .init(
          title: "돌봄 조건",
          textAlignment: .left
        )
      )
      
      EmptyComponent(height: 20)
      
      SelectConditionHorizontalComponent(viewModel: .init(
        systemImageName: "heart.fill",
        conditionTitle: "성별",
        rightConditionView: SegmentControlView(segmentTitles: ["남자만", "여자만", "상관없음"], stackViewSpacing: 4),
        maxWidthForRightConditionView: nil
      ))
      
      
      EmptyComponent(height: 20)
      
      SelectConditionHorizontalComponent(viewModel: .init(
        systemImageName: "pawprint.fill",
        conditionTitle: "돌봄형태",
        rightConditionView: ButtonSegmentControlView(segmentTitles: ["방문돌봄", "위탁돌봄"]),
        maxWidthForRightConditionView: nil
      ))
      
      EmptyComponent(height: 20)
      
      
      SelectDateHorizontalComponent(viewModel: .init())
        .onDateChange { [weak self] date in
          self?.viewStore.send(.onDateChange(date))
        }
      
      EmptyComponent(height: 20)
      
      
      SelectConditionHorizontalComponent(viewModel: .init(
        systemImageName: "coloncurrencysign.circle.fill",
        conditionTitle: "페이",
        rightConditionView: BaseFilledTextField()
          .configure(viewModel: .init(
            textFieldPlaceHolder: "원",
            maxCharactersLimit: 10
          )),
        maxWidthForRightConditionView: 126
      ))
      .onEditingChanged { text, _ in
      
      }
      
      
      EmptyComponent(height: 26)
    
      
      EmptyComponent(height: 20)
    }
  }
  
  init(store: some StoreOf<SelectCareConditionFeature>) {
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
    
    configureTopLeftTitle("")
    
    hidesBottomBarWhenPushed = true
    
    bottomButton = BaseBottomButton()
    bottomButton.set {
      view.addSubview($0)
      $0.configure(viewModel: .init(
        isEnabled: viewStore.publisher.isBottomButtonEnabled,
        buttonTitle: "다음 단계로"
      ))
      
      $0.onTap { [weak self] in
        self?.viewStore.send(.didTapBottomButton)
      }
      
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

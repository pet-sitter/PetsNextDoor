//
//  SelectPetViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/30.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

final class SelectPetViewController: BaseViewController, RenderableViewProvidable {
  
  private let viewStore: ViewStoreOf<SelectPetFeature>
  
  private var tableView: UITableView!
  private var bottomButton: BaseBottomButton!
  
  private lazy var adapter = UITableViewAdapter(target: tableView)
  private lazy var renderer = Renderer(adapter: adapter)
  
  var renderableView: RenderableView {
    Section {
      EmptyComponent(height: 24)
      HeaderTitleComponent(
        viewModel: .init(
          title: "반려동물 선택",
          textAlignment: .left
        )
      )

      EmptyComponent(height: 16)
      
			For(each: viewStore.selectPetCellViewModels) { cellVM in
        List {
          SelectPetComponent(viewModel: cellVM)
          EmptyComponent(height: 16)
        }
      }
    }
  }
  

  init(store: some StoreOf<SelectPetFeature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init()
		self.hidesBottomBarWhenPushed = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewStore.send(.viewDidLoad)
    bindState()
    renderer.render { renderableView }
    
    adapter
      .onSelection { [weak self] selectionInfo in
        guard let petVM = selectionInfo.component.viewModel as? SelectPetViewModel else { return }
        self?.viewStore.send(.didSelectPet(petVM))
      }
      
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func configureUI() {
    super.configureUI()

    
    configureTopLeftTitle("")
    
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

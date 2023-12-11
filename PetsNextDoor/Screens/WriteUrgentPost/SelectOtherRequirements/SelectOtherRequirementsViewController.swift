//
//  SelectOtherRequirementsViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/10.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

struct SelectOtherRequirementsFeature: Reducer {
  
  struct State: Equatable {
    var isBottomButtonEnabled: Bool = true
    
    fileprivate var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable {
    
    case didTapBottomButton
    
    // Internal Cases
    case _routeAction(Router<PND.Destination>.Action)
  }
  
  var body: some Reducer<State,Action> {
    
    Scope(
      state: \.router,
      action: /Action._routeAction
    ) {
      Router<PND.Destination>()
    }
    
    Reduce { state, action in
      switch action {
      case .didTapBottomButton:
        return .send(._routeAction(.pushScreen(.writeUrgentPost(state: .init()), animated: true)))
        
      default:
        return .none
      }
    }
  }
}

final class SelectOtherRequirementsViewController: BaseViewController, RenderableViewProvidable {
  
  private let viewStore: ViewStoreOf<SelectOtherRequirementsFeature>
  
  private var tableView: UITableView!
  private var bottomButton: BaseBottomButton!
  
  private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
  
  var renderableView: RenderableView {
    Section {
      EmptyComponent(height: 24)
      HeaderTitleComponent(
        viewModel: .init(
          attributedTitle: NSAttributedString {
            AText("기타 요청사항")
              .font(.systemFont(ofSize: 20, weight: .bold))
            AText("(필수 선택)")
              .font(.systemFont(ofSize: 20, weight: .bold))
              .foregroundColor(PND.Colors.primary)
          },
          textAlignment: .left
        )
      )
      EmptyComponent(height: 20)
      
      SelectConditionHorizontalComponent(viewModel: .init(
        systemImageName: "person.2.fill",
        conditionTitle: "CCTV, 펫캠 촬영 동의",
        rightConditionView: BaseCheckBoxButton()
          .configure(viewModel: .init(isChecked: false)),
        maxWidthForRightConditionView: BaseCheckBoxButton.defaultHeight
      ))
      
      EmptyComponent(height: 14)
      
      SelectConditionHorizontalComponent(viewModel: .init(
        systemImageName: "person.2.fill",
        conditionTitle: "사전 통화 가능 여부",
        rightConditionView: BaseCheckBoxButton()
          .configure(viewModel: .init(isChecked: false)),
        maxWidthForRightConditionView: BaseCheckBoxButton.defaultHeight
      ))
			
			EmptyComponent(height: 14)
			
			SelectConditionHorizontalComponent(viewModel: .init(
				systemImageName: "person.2.fill",
				conditionTitle: "반려 동물 등록 여부",
				rightConditionView: BaseCheckBoxButton()
					.configure(viewModel: .init(isChecked: false)),
				maxWidthForRightConditionView: BaseCheckBoxButton.defaultHeight
			))
			
			
			
    }
  }
  
  init(store: some StoreOf<SelectOtherRequirementsFeature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    renderer.render { renderableView }
  }
  
  override func configureUI() {
    super.configureUI()
    
    hidesBottomBarWhenPushed = true
    
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
  
  
  
}

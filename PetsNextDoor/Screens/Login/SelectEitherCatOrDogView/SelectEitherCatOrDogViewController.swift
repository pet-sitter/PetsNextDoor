//
//  SelectEitherCatOrDogViewController.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 11/26/23.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

struct SelectEitherCatOrDogFeature: Reducer {
	
	struct State: Equatable, RoutableState {
		var router: Router<PND.Destination>.State = .init()
		var isBottomButtonEnabled: Bool = false
		var selectedPetType: PND.PetType? = nil

    var addPetState: AddPetFeature.State?
	}
	
	enum Action: Equatable, RestrictiveAction {
    
    enum ViewAction: Equatable {
      case viewDidAppear
      case onPetSelection(PND.PetType)
      case didTapBottomButton
      case onDismiss
    }
    
    enum DelegateAction: Equatable {
      case dismissComplete
      case onPetAddComplete(AddPetFeature.State)
    }
    
    enum InternalAction: Equatable {

    }
    
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
    
    case _addPetAction(AddPetFeature.Action)
    case _routeAction(Router<PND.Destination>.Action)
	}
	
	var body: some Reducer<State, Action> {
		Scope(
			state: \.router,
      action: /Action._routeAction
    ) {
      Router<PND.Destination>()
    }
    
		Reduce { state, action in
			switch action {
      
      case .view(.viewDidAppear):
        state.addPetState = nil
        return .none

      case .view(.onPetSelection(let petType)):
				state.selectedPetType = petType
				state.isBottomButtonEnabled = true
				return .none
				
      case .view(.didTapBottomButton):
        guard let petType = state.selectedPetType else { return .none }
        state.addPetState = AddPetFeature.State(selectedPetType: petType)
        return .none
        
      case .view(.onDismiss):
        
        return .merge([
          .send(._routeAction(.dismiss(completion: nil))),
          .send(.delegate(.dismissComplete))
        ])
        
        
      case ._addPetAction(.onPetAddition):
        if let addPetState = state.addPetState {
          return .send(.delegate(.onPetAddComplete(addPetState)))
        }
        return .none
        
				
			default: return .none
			}
		}
    .ifLet(
      \.addPetState,
       action: /Action._addPetAction
    ) {
      AddPetFeature()
    }
	}
}

final class SelectEitherCatOrDogViewController: BaseViewController, RenderableViewProvidable {
	
	private var tableView: BaseTableView!
	private var bottomButton: BaseBottomButton!
	
  private let store: StoreOf<SelectEitherCatOrDogFeature>
	private let viewStore: ViewStoreOf<SelectEitherCatOrDogFeature>
	
	private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
	
	var renderableView: RenderableView {
		Section {
			
			EmptyComponent(height: 32)
			
			HeaderTitleComponent(viewModel: .init(
				title: "함께하는 반려동물을 선택해주세요.",
				textAlignment: .left,
				font: .systemFont(ofSize: 20, weight: .medium)
			))
			
			EmptyComponent(height: 32)
			
			SelectEitherCatOrDogComponent(
				viewModel: .init(
					onPetSelection: { [weak self] petType in
            self?.viewStore.send(.view(.onPetSelection(petType)))
					}
				)
			)

		}
	}
	
	init(store: some StoreOf<SelectEitherCatOrDogFeature>) {
    self.store     = store
		self.viewStore = ViewStore(store, observe: { $0 })
		super.init()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		renderer.render { renderableView }
    bindState()
	}
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewStore.send(.view(.viewDidAppear))
  }
	
	override func configureUI() {
		super.configureUI()
		
		configureNavigationBarItems()
		configureTopLeftTitle("반려동물 추가하기")
		
		bottomButton = BaseBottomButton()
		bottomButton.set {
			view.addSubview($0)
			$0.configure(viewModel: .init(isEnabled: viewStore.publisher.isBottomButtonEnabled, buttonTitle: "완료"))
			$0.snp.makeConstraints {
				$0.bottom.equalToSuperview().inset(UIScreen.safeAreaBottomInset).inset(50)
				$0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
				$0.height.equalTo(BaseBottomButton.defaultHeight)
			}

			$0.onTapGesture { [weak self] in
        self?.viewStore.send(.view(.didTapBottomButton))
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
	
	private func configureNavigationBarItems() {
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			title: nil,
			image: UIImage(systemName: "xmark"),
			primaryAction: .init(handler: { [weak self] _ in
        self?.viewStore.send(.view(.onDismiss))
			})
		)

	}
  
  private func bindState() {
    
    store.scope(
      state: \.addPetState,
      action: SelectEitherCatOrDogFeature.Action._addPetAction
    )
    .ifLet(then: { store in
      AppRouter.shared.receive(.pushScreen(.custom(AddPetViewController(store: store))))
    })
    .store(in: &subscriptions)
  }
}

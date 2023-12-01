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
		
	}
	
	enum Action: Equatable, RoutableAction {
		case onPetSelection(PND.PetType)
		case didTapBottomButton
		case onDismiss
		
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
				
			case .onPetSelection(let petType):
				state.selectedPetType = petType
				state.isBottomButtonEnabled = true
				return .none
				
			case .didTapBottomButton:
        return .send(._routeAction(.pushScreen(.addPet(AddPetFeature.State(selectedPetType: state.selectedPetType ?? .dog)), animated: true)))
				
			case .onDismiss:
				return .send(._routeAction(.dismiss(completion: nil)))
				
			default: return .none
			}
		}
	}
}

final class SelectEitherCatOrDogViewController: BaseViewController, RenderableViewProvidable {
	
	private var tableView: BaseTableView!
	private var bottomButton: BaseBottomButton!
	
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
						self?.viewStore.send(.onPetSelection(petType))
					}
				)
			)

		}
	}
	
	init(store: some StoreOf<SelectEitherCatOrDogFeature>) {
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
				self?.viewStore.send(.didTapBottomButton)
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
				self?.viewStore.send(.onDismiss)
			})
		)

	}
	
		
}

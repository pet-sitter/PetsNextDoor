//
//  SetProfileViewController.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

final class SetProfileViewController: BaseViewController {
	
	private var tableView: UITableView!
	private var bottomButton: BaseBottomButton!
	private var adapter: TableViewAdapter!
	
	typealias Feature = SetProfileFeature
	typealias State   = SetProfileFeature.State
	typealias Action  = SetProfileFeature.Action
	
	private let viewStore: ViewStoreOf<Feature>
	private let router: Routable
	
	@Published var components: [any Component] = []
	
	init(
		store:  some StoreOf<Feature>,
		router: some Routable
	) {
		self.viewStore  = ViewStore(store, observe: { $0 } )
		self.router     = router
		super.init()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func configureUI() {
		super.configureUI()
		
		bottomButton = BaseBottomButton(title: "완료하기")
		bottomButton.set {
			view.addSubview($0)
			$0.snp.makeConstraints {
				$0.bottom.equalToSuperview().inset(UIScreen.safeAreaBottomInset).inset(50)
				$0.leading.trailing.equalToSuperview().inset(20)
				$0.height.equalTo(BaseBottomButton.defaultHeight)
			}
			$0.onTapGesture { [weak self] in
				
			}
		}
		
		tableView = BaseTableView()
		tableView.set {
			view.addSubview($0)
			$0.registerCell(ContainerCell<SetProfileImageComponent>.self)
			$0.registerCell(ContainerCell<TextFieldComponent>.self)
			$0.snp.makeConstraints {
				$0.top.leading.trailing.equalToSuperview()
				$0.bottom.equalTo(bottomButton.snp.top)
			}
		}
		
		adapter = TableViewAdapter(tableView: tableView)
		adapter.observeDataSource(componentPublisher: $components)
    
		components = ComponentBuilder {
			SetProfileImageComponent()
        .onTouch { _ in
        }
			EmptyComponent(height: 20)
			TextFieldComponent(
        context: .init(
          textFieldPlaceHolder: "닉네임 (2~10자 이내)",
          maxCharactersLimit: 10,
          rightView: { [weak self] () -> UILabel in
            guard let self else { return .init() }
            let label = UILabel()
              .frame(width: 120, height: 14)
              .font(.systemFont(ofSize: 12, weight: .medium))
              .color(.init(hex: "#6A9DFF"))
              .rightAlignment()
      
            viewStore.publisher
              .nicknameStatusPhrase
              .sink { label.text($0) }
              .store(in: &subscriptions)
            return label
          }()
        )
      )
      .onEditingChanged { [weak self] text, textComponent in
        self?.viewStore.send(.textDidChange(text))
      }
		}
	}
	
	private func bindState() {

		
		
	}
	
}

//
//  AuthenticatePhoneNumberViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/16.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

final class AuthenticatePhoneNumberViewController: BaseViewController {
  
  private var tableView: UITableView!
  private var bottomButton: BaseBottomButton!
  
  private lazy var adapter = TableViewAdapter(tableView: tableView)
  
  typealias Feature = AuthenticateFeature
  typealias State   = AuthenticateFeature.State
  typealias Action  = AuthenticateFeature.Action

  private let store: Store<State, Action>
  private let viewStore: ViewStoreOf<Feature>
  private let router: Routable
  
  init(
    store:  some StoreOf<Feature>,
    router: some Routable
  ) {
    self.store      = store
    self.viewStore  = ViewStore(store, observe: { $0 } )
    self.router     = router
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureActions()
    bindState()
  }
  
  private func configureUI() {
    bottomButton = BaseBottomButton(title: "다음")
    bottomButton.set {
      view.addSubview($0)
      $0.snp.makeConstraints {
        $0.bottom.equalToSuperview().inset(UIScreen.safeAreaBottomInset).inset(25)
        $0.leading.trailing.equalToSuperview().inset(20)
        $0.height.equalTo(BaseBottomButton.defaultHeight)
      }
      $0.onTapGesture { [weak self] in
        self?.viewStore.send(.didTapNextButton)
      }
    }
    
    tableView = UITableView()
    tableView.set {
      view.addSubview($0)
      $0.backgroundColor = .systemGray6
      $0.registerCell(ContainerCell<TextFieldComponent>.self)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(bottomButton.snp.top)
      }
    }
    
    
    
 
    
  }
    
  
  private func configureActions() {
    
  }
  
  private func bindState() {
    
    viewStore
      .publisher
      .map { $0.nextDestination }
      .compactMap { $0 }
      .sink { [weak self] destination in
        defer { self?.viewStore.send(.setNextDestination(nil)) }
        self?.router.route(to: destination)
      }
      .store(in: &subscriptions)
    
    
  }



}

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
  
  private var tableView: BaseTableView!
  private var bottomButton: BaseBottomButton!
  private var adapter: TableViewAdapter!
  
  typealias Feature = AuthenticateFeature
  typealias State   = AuthenticateFeature.State
  typealias Action  = AuthenticateFeature.Action
  
  private let viewStore: ViewStoreOf<Feature>
  
  @Published var components: [any Component] = []
  
  init(store: some StoreOf<Feature>) {
    self.viewStore  = ViewStore(store, observe: { $0 } )
    super.init()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindState()
  }
  
  override func configureUI() {
    super.configureUI()
    
    configureTopLeftTitle("프로필 설정하기")
    
    bottomButton = BaseBottomButton(title: "다음")
    bottomButton.set {
      view.addSubview($0)
      $0.snp.makeConstraints {
        $0.bottom.equalToSuperview().inset(UIScreen.safeAreaBottomInset).inset(50)
        $0.leading.trailing.equalToSuperview().inset(20)
        $0.height.equalTo(BaseBottomButton.defaultHeight)
      }
      $0.onTapGesture { [weak self] in
        self?.viewStore.send(.didTapNextButton)
      }
    }
    
    tableView = BaseTableView()
    tableView.set {
      view.addSubview($0)
      $0.registerCell(ContainerCell<TextFieldComponent>.self)
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(bottomButton.snp.top)
      }
    }
    
    adapter = TableViewAdapter(tableView: tableView)
    adapter.set {
      $0.observeDataSource(componentPublisher: $components)
    }
    
    

    components = ComponentBuilder {
      EmptyComponent(height: 20)
      TextFieldComponent(
        context: .init(
          textFieldPlaceHolder: "휴대폰 번호",
          rightView: BaseButton(isEnabled: viewStore.publisher.authenticateButtonIsEnabled)
            .bgColor(.black)
            .title("인증하기")
            .frame(width: 65, height: 32)
            .titleStyle(font: .systemFont(ofSize: 12, weight: .regular), color: .white)
            .roundCorners(radius: 50)
            .onViewTap { [weak self] in
              self?.viewStore.send(.didTapAuthenticateButton)
            }
        )
      )
      .onEditingChanged { text, _ in
        
      }
      
      EmptyComponent(height: 20)
      TextFieldComponent(
        context: .init(
          textFieldPlaceHolder: "인증번호 6자리",
          rightView: {
            let countDownLabel = CountDownLabel()
              .frame(width: 33, height: 15)
            
            viewStore
              .publisher
              .timerMilliseconds
              .compactMap { $0 }
              .sink { milliseconds in
                countDownLabel.configureTimer(milliseconds: milliseconds)
              }
              .store(in: &subscriptions)
            
            
            countDownLabel.onTimerEnd = { [weak self] in
              self?.viewStore.send(.didEndCountDownTimer)
            }
            
            return countDownLabel
          }()
        )
      )
    }
  }
  
  private func bindState() {
    
    
  }
}

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
  
  typealias Feature = AuthenticateFeature
  typealias State   = AuthenticateFeature.State
  typealias Action  = AuthenticateFeature.Action
  
  private let viewStore: ViewStoreOf<Feature>
  
  private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
  
  init(store: some StoreOf<Feature>) {
    self.viewStore  = ViewStore(store, observe: { $0 } )
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configureUI() {
    super.configureUI()
    
    configureTopLeftTitle("프로필 설정하기")
    
    bottomButton = BaseBottomButton()
    bottomButton.set {
      view.addSubview($0)
      $0.configure(viewModel: .init(isEnabled: true, buttonTitle: "다음"))
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
      $0.snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.bottom.equalTo(bottomButton.snp.top)
      }
    }
    
    renderer.render {
      List {
        EmptyComponent(height: 20)
        
        TextFieldComponent(
          viewModel: .init(
            textFieldPlaceHolder: "휴대폰 번호",
            rightView: BaseButton(isEnabled: viewStore.publisher.authenticateButtonIsEnabled)
              .bgColor(.black)
              .title("인증하기")
              .frame(width: 65, height: 32)
              .titleStyle(font: .systemFont(ofSize: 12, weight: .regular), color: .white)
              .roundCorners(radius: 50)
              .onTap { [weak self] in
                self?.viewStore.send(.didTapAuthenticateButton)
              }
          )
        )
        .onEditingChanged { text, _ in
          
        }
        
        EmptyComponent(height: 20)
        
        TextFieldComponent(
          viewModel: .init(
            textFieldPlaceHolder: "인증번호 6자리",
            rightView: CountDownLabel()
              .frame(width: 33, height: 15)
              .bindValue(viewStore.publisher.timerMilliseconds)
              .onTimerEnd { [weak self] in
                self?.viewStore.send(.didEndCountDownTimer)
              }
          )
        )
      }
    }
  }
}

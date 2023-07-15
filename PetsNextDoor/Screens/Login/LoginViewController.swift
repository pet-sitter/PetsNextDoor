//
//  LoginViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/06/17.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit
import GoogleSignIn

final class LoginViewController: BaseViewController {
  
  private var socialLogInStackView: UIStackView!
  
  private var googleLoginButton: GIDSignInButton!
  
  private var store = Store(
    initialState: LoginViewReducer.State(),
    reducer: LoginViewReducer(authenticationMiddleWare: AuthenticationMiddleWare(loginService: LoginService()))
  )
  private var router: Routable? = nil

  
  override init() {
    super.init()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureActions()
    bindState()
    view.backgroundColor = .systemTeal

    self.router = LoginRouter(outputStream: store.outputStream)
  }
  
  private func configureUI() {
    
    socialLogInStackView = UIStackView()
    view.addSubview(socialLogInStackView)
    socialLogInStackView.set {
      $0.spacing = 5
      $0.axis = .horizontal
      $0.snp.makeConstraints {
        $0.bottom.equalToSuperview().inset(100)
        $0.leading.trailing.equalToSuperview().inset(50)
      }
    }
    
    googleLoginButton = GIDSignInButton(frame: .init(x: 0, y: 0, width: 70, height: 70))
    socialLogInStackView.addArrangedSubview(googleLoginButton)
    
  }
  
  
  private func configureActions() {
    
    googleLoginButton.controlEventPublisher(for: .touchUpInside)
      .sink { [weak self] _ in
        self?.store.send(.didTapGoogleLogin)
      }
      .store(in: &subscriptions)
    
  }
  
  
  private func bindState() {
    
    store.$state
      .map { $0.isLoadingIndicatorAnimating }
      .assignNoRetain(to: \.isAnimating, on: loadingIndicator)
      .store(in: &subscriptions)

  }
  
}


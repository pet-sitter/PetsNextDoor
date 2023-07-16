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
  
  private var logoImageView: UIImageView!
  
  private var socialLogInStackView: UIStackView!
  private var googleLoginButton: UIButton!
  private var kakaoLoginButton: UIButton!
  private var appleLoginButton: UIButton!
  
  private struct Constants {
    static let socialLoginButtonSize: CGSize = .init(width: 67, height: 67)
  }
  
  typealias StoreType = Store<LoginViewReducer.State, LoginViewReducer.Action, LoginViewReducer.Feedback, LoginViewReducer.Output>

  private let store: StoreType
  private let router: Routable

  
  init(store: StoreType, router: Routable) {
    self.store  = store
    self.router = router
    super.init()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureActions()
    bindState()
  }
  
  private func configureUI() {
    
    logoImageView = UIImageView(image: UIImage(resource: R.image.loginImage))
    view.addSubview(logoImageView)
    logoImageView.set {
      $0.snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(200)
      }
    }
    
    socialLogInStackView = UIStackView()
    view.addSubview(socialLogInStackView)
    socialLogInStackView.set {
      $0.spacing      = 15
      $0.axis         = .horizontal
      $0.distribution = .equalSpacing
      $0.alignment    = .center
      $0.snp.makeConstraints {
        $0.bottom.equalToSuperview().inset(100)
        $0.centerX.equalToSuperview()
      }
    }
    
    googleLoginButton = UIButton()
    socialLogInStackView.addArrangedSubview(googleLoginButton)
    googleLoginButton.set {
      $0.setImage(UIImage(resource: R.image.googleLogin), for: .normal)
      $0.frame = .init(origin: .default, size: Constants.socialLoginButtonSize)
    }
    
    kakaoLoginButton = UIButton()
    socialLogInStackView.addArrangedSubview(kakaoLoginButton)
    kakaoLoginButton.set {
      $0.setImage(UIImage(resource: R.image.kakaoLogin), for: .normal)
      $0.frame = .init(origin: .default, size: Constants.socialLoginButtonSize)
    }
    
    appleLoginButton = UIButton()
    socialLogInStackView.addArrangedSubview(appleLoginButton)
    appleLoginButton.set {
      $0.setImage(UIImage(resource: R.image.appleLogin), for: .normal)
      $0.frame = .init(origin: .default, size: Constants.socialLoginButtonSize)
    }
    

    
  }
  
  
  private func configureActions() {
    
    googleLoginButton
      .onTap { [weak self] in self?.store.dispatch(.didTapGoogleLogin) }
    
    kakaoLoginButton
      .onTap { [weak self] in self?.store.dispatch(.didTapKakaoLogin) }
    
    appleLoginButton
      .onTap { [weak self] in self?.store.dispatch(.didTapAppleLogin) }
    
    
    
  }
  
  
  private func bindState() {
    
    store.$state
      .map { $0.isLoadingIndicatorAnimating }
      .assignNoRetain(to: \.isAnimating, on: loadingIndicator)
      .store(in: &subscriptions)

  }
  
}


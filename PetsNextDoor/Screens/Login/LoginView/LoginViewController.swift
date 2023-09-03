//
//  LoginViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/06/17.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

final class LoginViewController: BaseViewController {
  
  private var logoImageView: UIImageView!
  private var socialLogInStackView: UIStackView!
  private var googleLoginButton: UIButton!
  private var kakaoLoginButton: UIButton!
  private var appleLoginButton: UIButton!
  
  private struct Constants {
    static let socialLoginButtonSize: CGSize = .init(width: 67, height: 67)
  }
	
	typealias State 	= LoginFeature.State
	typealias Action 	= LoginFeature.Action

	private let store: Store<State, Action>
  private let viewStore: ViewStoreOf<LoginFeature>
	
	init(store: some StoreOf<LoginFeature>) {
		self.store = store
		self.viewStore = ViewStore(store, observe: { $0 } )
		super.init()
	}
	
  override func viewDidLoad() {
    super.viewDidLoad()
    configureActions()
    bindState()
    configureTopLeftTitle("휴대폰 번호 인증하기")
  }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewStore.send(.viewWillAppear)
	}
  
  override func configureUI() {
    super.configureUI()
    
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
      .onTapGesture { [weak self] in self?.viewStore.send(.didTapGoogleLogin) }
    
    kakaoLoginButton
      .onTapGesture { [weak self] in self?.viewStore.send(.didTapKakaoLogin) }
    
    appleLoginButton
      .onTapGesture { [weak self] in self?.viewStore.send(.didTapAppleLogin) }
  }
  
  private func bindState() {
    
    viewStore
      .publisher
      .isLoading
      .receive(on: DispatchQueue.main)
      .assignNoRetain(to: \.isAnimating, on: loadingIndicator)
      .store(in: &subscriptions)
  }
}


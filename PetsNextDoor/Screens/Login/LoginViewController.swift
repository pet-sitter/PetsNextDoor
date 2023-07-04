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
    
    private var store: Store<LoginState> = .init(
        initialState: LoginState(),
        reducer: LoginState.reducer,
        middleWares: [:]
    )
    
    
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
                self?.store.dispatch(LoginStateAction.didTapGoogleLogin)
            }
            .store(in: &subscriptions)
            
    }
    

    private func bindState() {
    
        
        store.mainState
            .map { $0.isLoading }
            .removeDuplicates()
            .sink { isLoading in
                print("✅ isLoadingTriggered to: \(isLoading)")
            }
            .store(in: &subscriptions)
    }
    
}


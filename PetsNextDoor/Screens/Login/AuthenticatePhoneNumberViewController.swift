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

  private var phoneNumberTextField: BaseTextFieldView!
  private var verificationNumberTextField: BaseTextFieldView!
  private var nextButton: BaseButton!
  
  private let viewStore: ViewStoreOf<AuthenticationPhoneNumberCore>
  
  init(store: StoreOf<AuthenticationPhoneNumberCore>) {
    self.viewStore = ViewStore(store, observe: { $0} )
    super.init()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
		view.backgroundColor = .systemRed
		
  }
  
  override func configureUI() {
    super.configureUI()
    
    navigationController?.navigationItem.largeTitleDisplayMode = .never
    configureTopLeftTitle("휴대폰 번호 인증하기")
    
    phoneNumberTextField = BaseTextFieldView(textFieldPlaceHolder: "휴대폰 번호")
    phoneNumberTextField.set {
      view.addSubview($0)
      $0.snp.makeConstraints {
        $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(25)
        $0.leading.trailing.equalToSuperview().inset(25)
        $0.height.equalTo(BaseTextFieldView.defaultHeight)
      }
    }
    
    verificationNumberTextField = BaseTextFieldView(textFieldPlaceHolder: "인증번호 6자리")
    verificationNumberTextField.set {
      view.addSubview($0)
      $0.snp.makeConstraints {
        $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(15)
        $0.leading.trailing.equalToSuperview().inset(25)
        $0.height.equalTo(BaseTextFieldView.defaultHeight)
      }
    }
    
    nextButton = BaseButton(title: "다음으로")
    nextButton.set {
      view.addSubview($0)
      
      $0.snp.makeConstraints {
        $0.height.equalTo(BaseButton.defaultHeight)
        $0.leading.trailing.equalToSuperview().inset(25)
        $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(25)
      }
    }
  }
  



}

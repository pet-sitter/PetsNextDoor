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
import PhotosUI

final class SetProfileViewController: BaseViewController, RenderableViewProvidable {
	
	private var tableView: UITableView!
  private var bottomButton: BaseBottomButton!
	
	typealias Feature = SetProfileFeature
	typealias State   = SetProfileFeature.State
	typealias Action  = SetProfileFeature.Action
	
  private let store: StoreOf<Feature>
	private let viewStore: ViewStoreOf<Feature>
  
  private var photoPicker: PHPickerViewController?
  private var photoPickerConfiguration: PHPickerConfiguration {
    var config = PHPickerConfiguration()
    config.selectionLimit = 1
    config.filter = .images
    return config
  }
  
  private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
  
  var renderableView: RenderableView {
    Section {
      EmptyComponent(height: 20)
      
      SetProfileImageComponent(viewModel: .init(userImage: viewStore.publisher.selectedUserImage))
        .onTouch { [weak self] _ in
          self?.viewStore.send(.profileImageDidTap)
        }
      
      EmptyComponent(height: 20)
      
      TextFieldComponent(
        viewModel: .init(
          textFieldPlaceHolder: "닉네임 (2~10자 이내)",
          maxCharactersLimit: 10,
          rightView: BaseLabel(textValue: viewStore.publisher.nicknameStatusPhrase)
            .frame(width: 120, height: 14)
            .font(.systemFont(ofSize: 12, weight: .medium))
            .color(PND.Colors.commonBlue)
            .rightAlignment()
        )
      )
      .onEditingChanged { [weak self] text, textComponent in
        self?.viewStore.send(.textDidChange(text))
      }
      
      EmptyComponent(height: 20)
            
      if !viewStore.myPetCellViewModels.isEmpty {
				For(each: viewStore.myPetCellViewModels) { cellVM in
          List {
            SelectPetComponent(viewModel: cellVM)
              .onDelete { [weak self] _ in
                self?.viewStore.send(.didTapPetDeleteButton(cellVM))
              }
              
            EmptyComponent(height: 16)
          }
        }
      }
      
      EmptyComponent(height: 20)
      
      HorizontalActionButtonComponent(
        viewModel: .init(
          buttonTitle: "반려동물 추가하기",
          leftImage: UIImage(systemName: "plus")
        )
      )
      .onTouch { [weak self] _ in
        self?.viewStore.send(.didTapAddPetButton)
      }
      
    }
  }

	
	init(store: some StoreOf<Feature>) {
    self.store      = store
		self.viewStore  = ViewStore(store, observe: { $0 } )
		super.init()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
    renderer.render { renderableView }
		bindState()
	}
	
	override func configureUI() {
    super.configureUI()
    
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
  
  private func bindState() {
    
    store.scope(
      state: \.selectEitherCatOrDogState,
      action: SetProfileFeature.Action._selectEitherCatOrDogAction
    )
    .ifLet(then: { store in
//      AppRouter.shared.receive(.presentFullScreen(.custom(SelectEitherCatOrDogViewController(store: store))))
    })
    .store(in: &subscriptions)
    

    viewStore
      .publisher
      .myPetCellViewModels
      .withStrong(self)
      .sink { strongSelf, _ in
        strongSelf.renderer.render { strongSelf.renderableView }
      }
      .store(in: &subscriptions)
    
    viewStore.publisher
      .photoPickerIsPresented
      .receiveOnMainQueue()
      .ifFalse { [weak self] in
        self?.photoPicker?.dismiss(animated: true)
      }
      .ifTrue { [weak self] in
        guard let self else { return }
        photoPicker = PHPickerViewController(configuration: photoPickerConfiguration)
        photoPicker?.delegate = self
        present(photoPicker!, animated: true)
      }
      .sink { _ in }
      .store(in: &subscriptions)
    
    
    viewStore.publisher
      .isLoading
      .receiveOnMainQueue()
      .assignNoRetain(to: \.isAnimating, on: loadingIndicator)
      .store(in: &subscriptions)
	}
}

//MARK: - PHPickerViewControllerDelegate

extension SetProfileViewController: PHPickerViewControllerDelegate {
  
  func picker(
    _ picker: PHPickerViewController,
    didFinishPicking results: [PHPickerResult]
  ) {
    guard
      let itemProvider = results.first?.itemProvider,
      itemProvider.canLoadObject(ofClass: UIImage.self)
    else { return }
    
    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
      guard
        let self,
        let selectedImage = image as? UIImage
      else { return }
      Task { @MainActor [weak self] in
        self?.viewStore.send(.userImageDidChange(selectedImage))
      }
    }
  }
}

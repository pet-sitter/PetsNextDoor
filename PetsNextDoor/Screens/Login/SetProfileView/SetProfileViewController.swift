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

final class SetProfileViewController: BaseViewController {
	
	private var tableView: UITableView!
  private var bottomComponent: BottomButtonComponent!
	private var adapter: TableViewAdapter!
	
	typealias Feature = SetProfileFeature
	typealias State   = SetProfileFeature.State
	typealias Action  = SetProfileFeature.Action
	
	private let viewStore: ViewStoreOf<Feature>
	
	@Published var components: [any Component] = []
  
  private var photoPicker: PHPickerViewController?
  private var photoPickerConfiguration: PHPickerConfiguration {
    var config = PHPickerConfiguration()
    config.selectionLimit = 1
    config.filter = .images
    return config
  }
	
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
		    
    bottomComponent = BottomButtonComponent(context: .init(buttonTitle: "완료"))
      .bindValue(viewStore.publisher.isBottomButtonEnabled.eraseToAnyPublisher())
      
    let bottomButton = bottomComponent.createContentView()
    bottomButton.set {
      view.addSubview($0)
      $0.snp.makeConstraints {
        $0.bottom.equalToSuperview().inset(UIScreen.safeAreaBottomInset).inset(50)
        $0.leading.trailing.equalToSuperview().inset(20)
        $0.height.equalTo(BaseBottomButton.defaultHeight)
      }
      $0.onTapGesture { [weak self] in
        self?.viewStore.send(.didTapBottomButton)
         
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
      EmptyComponent(height: 20)
      SetProfileImageComponent()
        .onTouch { [weak self] _ in
          self?.viewStore.send(.profileImageDidTap)
        }
        .bindValue(viewStore.publisher.selectedUserImage.eraseToAnyPublisher())
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
              .compactMap { $0 }
              .assignNoRetain(to: \.text, on: label)
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
  
    viewStore.publisher
      .photoPickerIsPresented
      .receive(on: DispatchQueue.main)
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
      .receive(on: DispatchQueue.main)
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

//
//  WriteUrgentPostViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/10.
//

import UIKit
import PhotosUI
import Combine
import SnapKit
import ComposableArchitecture

struct WriteUrgentPostFeature: Reducer {
  
  struct State: Equatable {
    var isBottomButtonEnabled: Bool   = true
    var photoPickerIsPresented: Bool  = false
    var selectedUserImage: UIImage?
    
    fileprivate var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable {
    
    case profileImageDidTap
    case userImageDidChange(UIImage)
    
    // Internal Cases
    case _routeAction(Router<PND.Destination>.Action)
  }
  
  var body: some Reducer<State,Action> {
    
    Scope(
      state: \.router,
      action: /Action._routeAction
    ) {
      Router<PND.Destination>()
    }
    
    Reduce { state, action in
      switch action {
       
      case .profileImageDidTap:
        state.photoPickerIsPresented = true
        return .none
        
      case .userImageDidChange(let image):
        state.photoPickerIsPresented = false
        state.selectedUserImage = image
        return .none
        
      default:
        return .none
      }
    }
  }
}

final class WriteUrgentPostViewController: BaseViewController, RenderableViewProvidable {
  
  private let viewStore: ViewStoreOf<WriteUrgentPostFeature>
  
  private var tableView: UITableView!
  private var bottomButton: BaseBottomButton!
  
  private var photoPicker: PHPickerViewController?
  private var photoPickerConfiguration: PHPickerConfiguration {
    var config = PHPickerConfiguration()
    config.selectionLimit = 5
    config.filter = .images
    return config
  }
  
  private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
  
  var renderableView: RenderableView {
    Section {
      EmptyComponent(height: 24)
      
      EmptyTextFieldComponent(viewModel: .init(textFieldPlaceHolder: "돌봄 급구 제목을 입력해주세요."))
      
      EmptyComponent(height: 20)
      
      HeaderTitleComponent(viewModel: .init(
        title: "상세 설명",
        textAlignment: .left,
        font: .systemFont(ofSize: 16, weight: .bold))
      )
      
      EmptyComponent(height: 12)
      
      BaseTextViewComponent(viewModel: .init(
        placeHolder: "요청하고 싶은 돌봄에 대해 상세히 설명해주세요. 돌봄 시 반드시 숙지해야하는 주의사항을 적어주세요. ex) 실외배변을 위해 매일 2번 이상의 짧은 산책 필수"
      ))
      .onEditingChanged { text in
        
      }
      
      EmptyComponent(height: 100)
      
      SetProfileImageComponent(viewModel: .init(
        userImage: viewStore.publisher.selectedUserImage,
        imageViewAlignment: .left
      ))
      .onTouch { [weak self] _ in
        self?.viewStore.send(.profileImageDidTap)
      }
    }
  }
  
  init(store: some StoreOf<WriteUrgentPostFeature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindState()
    renderer.render { renderableView }
  }
  
  override func configureUI() {
    super.configureUI()
    
    hidesBottomBarWhenPushed = true
    
    bottomButton = BaseBottomButton()
    bottomButton.set {
      view.addSubview($0)
      $0.configure(viewModel: .init(
        isEnabled: viewStore.publisher.isBottomButtonEnabled,
        buttonTitle: "작성 완료"
      ))
      $0.snp.makeConstraints {
        $0.bottom.equalToSuperview().inset(UIScreen.safeAreaBottomInset).inset(50)
        $0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
        $0.height.equalTo(BaseBottomButton.defaultHeight)
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
  }
}

//MARK: - PHPickerViewControllerDelegate

extension WriteUrgentPostViewController: PHPickerViewControllerDelegate {
  
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

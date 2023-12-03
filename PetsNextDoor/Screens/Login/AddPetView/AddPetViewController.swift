//
//  AddPetViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/01.
//

import UIKit
import PhotosUI
import Combine
import SnapKit
import ComposableArchitecture

struct AddPetFeature: Reducer {
  
  struct State: Equatable, RoutableState {
    var router: Router<PND.Destination>.State = .init()
    var isBottomButtonEnabled: Bool = false
    
    let selectedPetType: PND.PetType = .dog
    
    var petImage: UIImage?
    var petName: String = ""
    var petAge: Int?
    var gender: PND.GenderType = .male
    var isNeutralized: Bool = false
    var speciesType: String = ""
    var birthday: String?
    var weight: Int?
    
    var otherInfo: String?
    
    var photoPickerIsPresented: Bool  = false
  }
  
  enum Action: Equatable, RoutableAction {
    case _routeAction(Router<PND.Destination>.Action)
    case petImageDidTap
    case petImageDidChange(UIImage)
    case textDidChange(String?)
    case didTapBottomButton
    case onPetAddition
  }
  
  var body: some Reducer<State,Action> {
    
    Scope(
      state: \.router,
      action: /Action._routeAction
    ) {
      Router<PND.Destination>()
    }
    
    Reduce { state, action in
      return .none
      switch action {

      case .petImageDidTap:
        state.photoPickerIsPresented = true
        return .none

      case .petImageDidChange(let image):
        state.photoPickerIsPresented = false
        state.petImage = image
        return .none

      case .textDidChange(let text):
        guard let text else { return .none }
        if text.count >= 2 && text.count <= 20 {
          state.petName = text
          state.isBottomButtonEnabled = true
        } else {
          state.isBottomButtonEnabled = false
        }
        return .none


      case .didTapBottomButton:

        state.petName = "아롱"
        state.speciesType = "비숑 프리제"
        state.petAge = 2
        state.isNeutralized = true
        
        return .send(.onPetAddition)
        
      case .onPetAddition:
        return .send(._routeAction(.dismiss()))
        
      default: return .none
      }
    }
  }
}

final class AddPetViewController: BaseViewController, RenderableViewProvidable {
  
  private var tableView: BaseTableView!
  private var bottomButton: BaseBottomButton!
  
  private let viewStore: ViewStoreOf<AddPetFeature>
  
  private lazy var renderer = Renderer(adapter: UITableViewAdapter(target: tableView))
  
  private var photoPicker: PHPickerViewController?
  private var photoPickerConfiguration: PHPickerConfiguration {
    var config = PHPickerConfiguration()
    config.selectionLimit = 1
    config.filter = .images
    return config
  }
  
  var renderableView: RenderableView {
    Section {
      EmptyComponent(height: 32)
      
      SetProfileImageComponent(viewModel: .init(userImage: viewStore.publisher.petImage))
        .onTouch { [weak self] _ in
          self?.viewStore.send(.petImageDidTap)
        }
      
      EmptyComponent(height: 32)
      
      TextFieldComponent(
        viewModel: .init(
          textFieldPlaceHolder: "반려동물 이름",
          maxCharactersLimit: 10
        )
      )
      .onEditingChanged { [weak self] text, textComponent in
        self?.viewStore.send(.textDidChange(text))
      }
      
      EmptyComponent(height: 20)
      
      
      SelectConditionHorizontalComponent(viewModel: .init(
        systemImageName: nil,
        conditionTitle: "성별",
        rightConditionView: SegmentControlView(segmentTitles: ["남자", "여자"]),
        maxWidthForRightConditionView: nil,
        titleLabelFont: .systemFont(ofSize: 20, weight: .semibold)
      ))
      
      EmptyComponent(height: 17)
      
      SelectConditionHorizontalComponent(viewModel: .init(
        systemImageName: nil,
        conditionTitle: "중성화 여부",
        rightConditionView: BaseCheckBoxButton()
          .configure(viewModel: .init(isChecked: false)),
        maxWidthForRightConditionView: BaseCheckBoxButton.defaultHeight,
        titleLabelFont: .systemFont(ofSize: 20, weight: .semibold)
      ))
      
      EmptyComponent(height: 17)
      
      SelectConditionHorizontalComponent(viewModel: .init(
        systemImageName: nil,
        conditionTitle: "묘종",
        rightConditionView: BaseEmptyTextFieldView()
          .configure(viewModel: .init(
            textFieldPlaceHolder: "묘종 입력하기",
            font: .systemFont(ofSize: 20, weight: .regular)
          )),
        maxWidthForRightConditionView: 126,
        titleLabelFont: .systemFont(ofSize: 20, weight: .semibold)
      ))
      
      EmptyComponent(height: 17)
      

      
      SelectConditionHorizontalComponent(viewModel: .init(
        systemImageName: nil,
        conditionTitle: "몸무게",
        rightConditionView: BaseFilledTextField()
          .configure(viewModel: .init(
            textFieldPlaceHolder: "kg",
            maxCharactersLimit: 10,
            backgroundColor: .clear,
            keyboardType: .numberPad
          )),
        maxWidthForRightConditionView: 126
      ))
      

    }
  }
  
  init(store: some StoreOf<AddPetFeature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    renderer.render { renderableView }
    bindState()
  }
  
  override func configureUI() {
    super.configureUI()
    
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

extension AddPetViewController: PHPickerViewControllerDelegate {
  
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
        self?.viewStore.send(.petImageDidChange(selectedImage))
      }
    }
  }
}

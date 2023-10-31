//
//  SelectCategoryView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/03.
//

import UIKit
import SnapKit

final class SelectCategoryViewModel: HashableViewModel {
  
}

final class SelectCategoryView: UIView {

  static let defaultHeight: CGFloat = 40
  
  private var containerView: UIView!
  
  private var filterOptionsLabel: UILabel!
  private var arrowDownImageView: UIImageView!
  
  private var petCategoryStackView: UIStackView!
  private var onlyDogsButton: CheckableButton!
  private var onlyCatsButton: CheckableButton!
  private var doesntMatterButton: CheckableButton!
  
  // 카테고리 버튼 배열
  private lazy var checkButtonArray: [CheckableButton] = [onlyDogsButton, onlyCatsButton, doesntMatterButton]
  
  // 현재 선택되어 있는 카테고리 버튼
  private lazy var selectedCheckButton: CheckableButton = doesntMatterButton
  
  // 현재 선택되어 있는 카테고리
  private(set) var selectedCategory: SelectCategoryView.Category = .doesntMatter
  
  // 카테고리 버튼 탭 액션 함수 (내부용)
  private lazy var onCheckableButtonTapped: ((CheckableButton) -> Void)? = { [weak self] button in
    guard let self else { return }
    
    if selectedCheckButton == button {
      button.isSelected = true
      return
    }
    
    selectedCheckButton = button
    
    switch button.tag {
    case Category.onlyDogs.rawValue:      selectedCategory = .onlyDogs
    case Category.onlyCats.rawValue:      selectedCategory = .onlyCats
    case Category.doesntMatter.rawValue:  selectedCategory = .doesntMatter
    default: return
    }
    
    checkButtonArray
      .filter  { $0 != button }
      .forEach { $0.isSelected = false }
    
    onCategoryButtonTap?(selectedCategory)
  }
  
  // 카테고리 버튼 탭 액션 함수 (외부용)
  var onCategoryButtonTap: ((SelectCategoryView.Category) -> Void)?
  
  enum Category: Int {
    case onlyDogs = 0
    case onlyCats
    case doesntMatter
  }
  
  init() {
    super.init(frame: .zero)
    configureUI()
    configureActions()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    containerView.set {
      addSubview($0)
      $0.backgroundColor = .clear
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    filterOptionsLabel = UILabel()
    filterOptionsLabel.set {
      containerView.addSubview($0)
      $0.font = .systemFont(ofSize: 16, weight: .bold)
      $0.text = "최신순"
      $0.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(25)
        $0.centerY.equalToSuperview()
      }
    }
    
    arrowDownImageView = UIImageView()
    arrowDownImageView.set {
      containerView.addSubview($0)
      $0.image = UIImage(resource: R.image.icon_arr_down)
      $0.contentMode = .scaleAspectFit
      $0.snp.makeConstraints {
        $0.leading.equalTo(filterOptionsLabel.snp.trailing).offset(4)
        $0.width.height.equalTo(16)
        $0.centerY.equalToSuperview()
      }
    }
    
    petCategoryStackView = UIStackView()
    petCategoryStackView.set {
      containerView.addSubview($0)
      $0.axis = .horizontal
      $0.distribution = .equalCentering
      $0.spacing = 9
      $0.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.trailing.equalToSuperview().inset(25)
      }
    }

    onlyDogsButton = CheckableButton(title: "강아지만")
    onlyDogsButton.set {
      petCategoryStackView.addArrangedSubview($0)
      $0.tag = Category.onlyDogs.rawValue
      $0.onButtonTap = onCheckableButtonTapped
    }
    
    onlyCatsButton = CheckableButton(title: "고양이만")
    onlyCatsButton.set {
      petCategoryStackView.addArrangedSubview($0)
      $0.tag = Category.onlyCats.rawValue
      $0.onButtonTap = onCheckableButtonTapped
    }
    
    doesntMatterButton = CheckableButton(title: "상관없음")
    doesntMatterButton.set {
      petCategoryStackView.addArrangedSubview($0)
      $0.tag = Category.doesntMatter.rawValue
      $0.onButtonTap = onCheckableButtonTapped
      $0.isSelected = true                                    // '상관없음' 옵션을 최초에 default로 지정
    }
  }
  
  private func configureActions() {
    
    filterOptionsLabel
      .onTap { [weak self] in self?.toggleFilterMenu() }
    
    arrowDownImageView
      .onTap { [weak self] in self?.toggleFilterMenu() }
  }
  
  private func toggleFilterMenu() {
    
  }
}

final class CheckableButton: UIButton {
  
  private let buttonTitle: String
  
  var onButtonTap: ((CheckableButton) -> Void)?

  init(title: String) {
    self.buttonTitle = title
    super.init(frame: .zero)
    configureUI()
    configureActions()
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  private func configureUI() {

    self
      .title(buttonTitle)
      .normalTitleStyle(font: .systemFont(ofSize: 12, weight: .regular), color: UIColor(hex: "#9E9E9E"))
      .selectedTitleStyle(font: .systemFont(ofSize: 12, weight: .semibold), color: PND.Colors.commonBlack)
      .bgColor(.clear)
      .selectedImage(UIImage(resource: R.image.icon_check))
      .normalImage(UIImage())
      .imageEdgeInsets(right: 2.0)
    
    self.isSelected = false
  }
  
  private func configureActions() {

    self.onTap { [weak self] in
      guard let self else { return }
      isSelected.toggle()
      onButtonTap?(self)
    }
  }
}

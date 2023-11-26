//
//  SelectPetView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/20.
//

import UIKit
import Combine
import SnapKit

final class SelectPetViewModel: HashableViewModel {

  let petImageUrlString: String
  let petName: String
  let petSpecies: String
  let petAge: Int
  let isPetNeutralized: Bool
  @Published var isPetSelected: Bool
  let isDeleteButtonHidden: Bool
  
  init(petImageUrlString: String, petName: String, petSpecies: String, petAge: Int, isPetNeutralized: Bool, isPetSelected: Bool, isDeleteButtonHidden: Bool) {
    self.petImageUrlString = petImageUrlString
    self.petName = petName
    self.petSpecies = petSpecies
    self.petAge = petAge
    self.isPetNeutralized = isPetNeutralized
    self.isPetSelected = isPetSelected
    self.isDeleteButtonHidden = isDeleteButtonHidden
  }
}

final class SelectPetView: UIView {
  
  static let defaultHeight: CGFloat = 100
  
  private var containerView: UIView!
  private var petImageView: UIImageView!
  private var petNameLabel: UILabel!
  private var petInformationLabel: UILabel!
  private var isNeutralizedLabel: UILabel!
  
  private var subscriptions = Set<AnyCancellable>()
  
  var onTap: (() -> Void)?
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    containerView.set {
      addSubview($0)
      $0.backgroundColor = .clear
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor(hex: "#D9D9D9").cgColor
      $0.layer.cornerRadius = 10
      $0.snp.makeConstraints {
        $0.top.bottom.equalToSuperview().inset(1)
        $0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
      }
    }
    
    petImageView = UIImageView()
    petImageView.set {
      containerView.addSubview($0)
      $0.contentMode = .scaleAspectFill
      $0.image = UIImage(named: "dog_test")
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 74 / 2
      $0.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(16)
        $0.top.bottom.equalToSuperview().inset(13)
        $0.width.equalTo(74)
      }
    }
    
    let stackView = UIStackView()
    stackView.set {
      containerView.addSubview($0)
      $0.axis = .vertical
      $0.distribution = .fillEqually
      $0.snp.makeConstraints {
        $0.top.equalToSuperview().inset(17)
        $0.leading.equalTo(petImageView.snp.trailing).offset(17)
        $0.bottom.equalToSuperview().inset(21)
        $0.trailing.equalToSuperview().inset(17)

      }
    }
    
    petNameLabel = UILabel()
    petNameLabel.set {
      stackView.addArrangedSubview($0)
      $0.font = .systemFont(ofSize: 16, weight: .bold)
      stackView.setCustomSpacing(4, after: $0)
    }
    
    petInformationLabel = UILabel()
    petInformationLabel.set {
      stackView.addArrangedSubview($0)
      $0.font = .systemFont(ofSize: 14, weight: .regular)
      stackView.setCustomSpacing(8, after: $0)
    }
    
    isNeutralizedLabel = UILabel()
    isNeutralizedLabel.set {
      stackView.addArrangedSubview($0)
			$0.frame = .init(x: 0, y: 0, width: 53, height: 18)
      $0.backgroundColor = UIColor(hex: "#FFF0DD")
      $0.textColor = PND.Colors.commonOrange
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 4
      $0.layer.borderColor = UIColor.clear.cgColor
      $0.layer.borderWidth = 1
      $0.font = .systemFont(ofSize: 12, weight: .bold)
    }
  }
  
  func configure(viewModel: SelectPetViewModel) {
    
    // 펫 이미지 설정
    
    petNameLabel.text = viewModel.petName
    petInformationLabel.text = viewModel.petSpecies + "  |  " + "\(viewModel.petAge)살"
    isNeutralizedLabel.text = viewModel.isPetNeutralized ? "중성화 O" : "중성화 X"
    
    isNeutralizedLabel.snp.makeConstraints {
      $0.width.equalTo(isNeutralizedLabel.intrinsicContentSize.width)
    }
    
    viewModel.$isPetSelected
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isSelected in
        self?.containerView.layer.borderColor = isSelected
        ? PND.Colors.commonOrange.cgColor
        : UIColor(hex: "#D9D9D9").cgColor
      }
      .store(in: &subscriptions)
    
    containerView
      .onTap { [weak self] in
        self?.onTap?()
      }
  }
}

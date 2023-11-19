//
//  MeetingCardView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/16.
//

import UIKit
import SnapKit
import Combine

struct MeetingCardViewModel: HashableViewModel {
  
  
}

final class MeetingCardView: UIView, HeightProvidable {
  
  static var defaultHeight: CGFloat { 112 }
  
  private var containerView: UIView!
  private var mainImageView: UIImageView!
  
  private var containerStackView: UIStackView!
  
  private var titleLabel: UILabel!
  
  private var descriptionStackView: UIStackView!
  private var peopleImageView: UIImageView!
  private var peopleInfoLabel: UILabel!
  private var chatStatusLabel: UILabel!
  
  private var tagStackView: UIStackView!
  
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    containerView.set {
      addSubview($0)
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    mainImageView = UIImageView()
    mainImageView.set {
      containerView.addSubview($0)
      $0.contentMode = .scaleAspectFill
      $0.image = UIImage(named: "dog_test")
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 4
      $0.snp.makeConstraints {
        $0.top.bottom.equalToSuperview().inset(12)
        $0.leading.equalToSuperview().inset(PND.Metrics.defaultSpacing)
        $0.width.height.equalTo(88)
      }
    }
    
    containerStackView = UIStackView()
    containerStackView.set {
      containerView.addSubview($0)
      $0.axis = .vertical
      $0.spacing = 5
      $0.distribution = .fillProportionally
      $0.snp.makeConstraints {
        $0.top.equalToSuperview().inset(12)
        $0.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
        $0.bottom.equalToSuperview().inset(12)
        $0.leading.equalTo(mainImageView.snp.trailing).offset(8)
      }
    }
    
    titleLabel = UILabel()
    titleLabel.set {
      containerStackView.addArrangedSubview($0)
      $0.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    
    descriptionStackView = UIStackView()
    descriptionStackView.set {
      containerStackView.addArrangedSubview($0)
      $0.spacing = 4
      $0.axis = .horizontal
    }
    
    peopleImageView = UIImageView()
    peopleImageView.set {
      descriptionStackView.addArrangedSubview($0)
      $0.image = UIImage(systemName: "person.2.fill")
      $0.tintColor = PND.Colors.commonOrange
      $0.snp.makeConstraints {
        $0.size.equalTo(16)
      }
    }
    
    peopleInfoLabel = UILabel()
    peopleInfoLabel.set {
      descriptionStackView.addArrangedSubview($0)
      $0.text = "6/10"
      $0.font = .systemFont(ofSize: 12, weight: .medium)
      $0.textColor = .color.commonBlack
    }
    
    
    chatStatusLabel = UILabel()
    chatStatusLabel.set {
      descriptionStackView.addArrangedSubview($0)
      $0.text = "방금 활동"
      $0.textColor = .color.commonBlue
      $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    
  }
  
  func configure(viewModel: MeetingCardViewModel) {
    
  }
}

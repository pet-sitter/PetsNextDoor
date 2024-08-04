//
//  UrgentPostCardView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/08.
//

import UIKit
import SnapKit
import Combine



final class UrgentPostCardView: UIView, HeightProvidable {
  
  static var defaultHeight: CGFloat { 112 }
  
  var containerView: UIView!
  var mainImageView: UIImageView!
  
  var containerStackView: UIStackView!
  
  var titleLabel: UILabel!
  
  var dateStackView: UIStackView!
  var calendarImageView: UIImageView!
  var dateLabel: UILabel!
  
  var locationStackView: UIStackView!
  var locationImageView: UIImageView!
  var locationLabel: UILabel!
  
  var costStackView: UIStackView!
  var costImageView: UIImageView!
  var costLabel: UILabel!
  
  private var subscriptions = Set<AnyCancellable>()
  
  private struct Constants {
    static let textFont: UIFont = .systemFont(ofSize: 12, weight: .medium)
  }
  
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
    
    dateStackView = UIStackView()
    dateStackView.set {
      containerStackView.addArrangedSubview($0)
      $0.axis = .horizontal
      $0.spacing = 6
    }
    
    
    calendarImageView = UIImageView()
    calendarImageView.set {
      dateStackView.addArrangedSubview($0)
      $0.image = UIImage(resource: .iconCal)
      $0.tintColor = PND.Colors.commonOrange
      $0.snp.makeConstraints {
        $0.width.height.equalTo(16)
      }
    }
    
    dateLabel = UILabel()
    dateLabel.set {
      dateStackView.addArrangedSubview($0)
      $0.text = "23.03.21 ~ 23.03.24 | 10:00 ~ 10:30"
      $0.font = Constants.textFont
    }
    
    locationStackView = UIStackView()
    locationStackView.set {
      containerStackView.addArrangedSubview($0)
      $0.axis = .horizontal
      $0.spacing = 6
    }
    
    locationImageView = UIImageView()
    locationImageView.set {
      locationStackView.addArrangedSubview($0)
      $0.image = UIImage(resource: .iconPin)
      $0.snp.makeConstraints {
        $0.width.height.equalTo(16)
      }
    }
    
    locationLabel = UILabel()
    locationLabel.set {
      locationStackView.addArrangedSubview($0)
      $0.text = "반포동"
      $0.font = Constants.textFont
    }
    
    costStackView = UIStackView()
    costStackView.set {
      containerStackView.addArrangedSubview($0)
      $0.axis = .horizontal
      $0.spacing = 6
    }
    
    costImageView = UIImageView()
    costImageView.set {
      costStackView.addArrangedSubview($0)
      $0.image = UIImage(resource: .iconPay)
      $0.tintColor = PND.Colors.commonOrange
      $0.snp.makeConstraints {
        $0.width.height.equalTo(16)
      }
    }
    
    costLabel = UILabel()
    costLabel.set {
      costStackView.addArrangedSubview($0)
      $0.text = "시급 10,000원"
      $0.font = Constants.textFont
    }
  }
  
  func configure(viewModel: UrgentPostCardViewModel) {
    titleLabel.text     = viewModel.postTitle
    dateLabel.text      = viewModel.date
    locationLabel.text  = viewModel.location
    costLabel.text      = viewModel.cost
  }
}

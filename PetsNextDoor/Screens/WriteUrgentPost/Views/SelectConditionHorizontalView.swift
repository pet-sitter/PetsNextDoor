//
//  SelectConditionView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/08.
//

import UIKit
import Combine
import SnapKit

final class SelectConditionViewModel: HashableViewModel {
  
  let systemImageName: String?
  let conditionTitle: String
  let rightConditionView: UIView
  var maxWidthForRightConditionView: CGFloat?
  var titleLabelFont: UIFont?
  
  init(
    systemImageName: String?,
    conditionTitle: String,
    rightConditionView: UIView,
    maxWidthForRightConditionView: CGFloat?,
    titleLabelFont: UIFont? = nil
  ) {
    self.systemImageName    = systemImageName
    self.conditionTitle     = conditionTitle
    self.rightConditionView = rightConditionView
    self.maxWidthForRightConditionView = maxWidthForRightConditionView
    self.titleLabelFont = titleLabelFont
  }
}

final class SelectConditionHorizontalView: UIView, HeightProvidable {

  static var defaultHeight: CGFloat { 30.0 }

  private var containerView: UIView!
  private var leftImageView: UIImageView!
  private var conditionTitleLabel: UILabel!
  private var rightConditionView: UIView?
  
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
      $0.snp.makeConstraints {
        $0.top.bottom.equalToSuperview()
        $0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
      }
    }
    
    leftImageView = UIImageView()
    leftImageView.set {
      containerView.addSubview($0)
      $0.contentMode = .scaleAspectFit
      $0.image = .init(systemName: "heart.fill")
      $0.tintColor = PND.Colors.commonBlack
      $0.snp.makeConstraints {
        $0.leading.top.bottom.equalToSuperview()
        $0.width.height.equalTo(24)
      }
    }
    
    conditionTitleLabel = UILabel()
    conditionTitleLabel.set {
      containerView.addSubview($0)
      $0.text = "조건"
      $0.font = .systemFont(ofSize: 20, weight: .bold)
      $0.textColor = PND.Colors.commonBlack
      $0.snp.makeConstraints {
        $0.leading.equalTo(leftImageView.snp.trailing).offset(5)
        $0.top.bottom.equalToSuperview()
      }
    }
    
  }
  
  func configure(viewModel: SelectConditionViewModel) {
    
    if let leftImage = viewModel.systemImageName {
      leftImageView.image = UIImage(systemName: leftImage)
    } else {
      leftImageView.isHidden = true
      leftImageView.removeFromSuperview()
      conditionTitleLabel.snp.remakeConstraints {
        $0.leading.top.bottom.equalToSuperview()
      }
    }

    conditionTitleLabel.text  = viewModel.conditionTitle
    
    if let titleLabelFont = viewModel.titleLabelFont {
      conditionTitleLabel.font = titleLabelFont
    }
    
    rightConditionView = viewModel.rightConditionView
    
    guard let rightConditionView else { return }
    
    rightConditionView.set {
      containerView.addSubview($0)

      $0.snp.makeConstraints {
        $0.top.bottom.trailing.equalToSuperview()
        if let maxWidth = viewModel.maxWidthForRightConditionView {
          $0.width.equalTo(maxWidth)
        } else {
          $0.leading.lessThanOrEqualTo(conditionTitleLabel.snp.trailing).offset(50)
        }
      }
    }
  }
}

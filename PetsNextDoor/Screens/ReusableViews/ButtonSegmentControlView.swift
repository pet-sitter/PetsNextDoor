//
//  ButtonSegmentControlView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/08.
//

import UIKit
import SnapKit

struct ButtoSegmentControlViewModel: HashableViewModel {
  let segmentTitles: [String]
}


final class ButtonSegmentControlView: UIView, HeightProvidable {
  
  static var defaultHeight: CGFloat = 40
  
  private var containerView: UIView!
  private var containerStackView: UIStackView!
  private var containerStackViewWidth: CGFloat = 0
  
  private(set) var selectedSegment: Int = 0
  
  private let segmentTitles: [String]
  private var segmentButtons: [UIButton]  = []
  
  var onSegmentTap: ((Int) -> Void)?
  
  private struct Constants {
    static let stackViewSpacing: CGFloat = 16.0
    static let fontSize: CGFloat = 20
  }
  
  init(segmentTitles: [String]) {
    self.segmentTitles = segmentTitles
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    containerView.set {
      addSubview($0)
      $0.backgroundColor = .clear
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    containerStackView = UIStackView()
    containerStackView.set {
      containerView.addSubview($0)
      $0.backgroundColor = .clear
      $0.axis = .horizontal
      $0.distribution = .equalCentering
      $0.spacing = Constants.stackViewSpacing
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    
    segmentTitles
      .enumerated()
      .forEach { index, title in
        
        let segmentButton = UIButton(type: .custom).tag(index)
        segmentButton.tag = index
        self.segmentButtons.append(segmentButton)
        
        segmentButton
          .normalTitleStyle(font: .systemFont(ofSize: Constants.fontSize, weight: .bold), color: PND.Colors.commonGrey)
          .selectedTitleStyle(font: .systemFont(ofSize: Constants.fontSize, weight: .bold), color: PND.Colors.commonWhite)
          .setBackgroundColor(PND.Colors.commonWhite, for: .normal)
          .setBackgroundColor(PND.Colors.commonBlack, for: .selected)
          .title(title)
//          .roundCorners(radius: 4)
//          .titleEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
          .onTap { [weak self] in
            self?.onSegmentTap?(index)
            segmentButton.isSelected = true
            self?.segmentButtons
              .filter   { $0.tag != index }
              .forEach  { $0.isSelected = false }
          }
        
        
        containerStackView.addArrangedSubview(segmentButton)
        
        containerStackViewWidth += title.calculateEstimateCGRect(
          fontSize: Constants.fontSize,
          size: CGSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: 24.0
          ),
          weight: .bold
        )
        .width
        
        containerStackViewWidth += Constants.stackViewSpacing
      }
    
    containerStackView.snp.remakeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.trailing.equalToSuperview().inset(4)
    }
  }
  
  func configure(viewModel: ButtoSegmentControlViewModel) {
    
  }
}

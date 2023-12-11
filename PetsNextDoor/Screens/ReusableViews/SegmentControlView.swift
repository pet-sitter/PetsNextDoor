//
//  SegmentControlView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/01.
//

import UIKit
import SnapKit

final class SegmentControlViewModel: HashableViewModel {
  let segmentTitles: [String]
  let stackViewSpacing: CGFloat
  
  init(segmentTitles: [String], stackViewSpacing: CGFloat) {
    self.segmentTitles = segmentTitles
    self.stackViewSpacing = stackViewSpacing
  }
}

final class SegmentControlView: UIView {
  
  static let defaultHeight: CGFloat = 40
  
  private var containerView: UIView!
  private var containerStackView: UIStackView!
  
  private(set) var selectedSegment: Int = 0
  
  private var stackViewSpacing: CGFloat
  
  private let segmentTitles: [String]
  private var segmentButtons: [UIButton]  = []
  
  var onSegmentTap: ((Int) -> Void)?
  
  private struct Constants {
    static let fontSize: CGFloat = 20
  }
  
  init(segmentTitles: [String], stackViewSpacing: CGFloat) {
    self.segmentTitles = segmentTitles
    self.stackViewSpacing = stackViewSpacing
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
      $0.spacing = stackViewSpacing
      $0.axis = .horizontal
      $0.distribution = .fillEqually
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
          .normalTitleStyle(font: .systemFont(ofSize: Constants.fontSize, weight: .bold), color: UIColor(hex: "#B3B3B3"))
          .selectedTitleStyle(font: .systemFont(ofSize: Constants.fontSize, weight: .bold), color: PND.Colors.primary)
          .bgColor(.clear)
          .title(title)
          .onTap { [weak self] in
            self?.onSegmentTap?(index)
            segmentButton.isSelected = true
            self?.segmentButtons
              .filter   { $0.tag != index }
              .forEach  { $0.isSelected = false }
          }
        containerStackView.addArrangedSubview(segmentButton)
        
      }
    
    segmentButtons
      .enumerated()
      .forEach { index, title in
        if index == 0 {
          segmentButtons[safe: 0]?.isSelected = true
        }
      }
    
//    containerStackView.snp.remakeConstraints {
//      $0.top.bottom.equalToSuperview()
//      $0.leading.equalToSuperview().inset(20)
//    }
  }
  
  func configure(viewModel: SegmentControlViewModel) {
    
    self.stackViewSpacing = viewModel.stackViewSpacing
    containerStackView.spacing = stackViewSpacing
    layoutIfNeeded()
    
4
    
  }
}

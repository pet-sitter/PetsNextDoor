//
//  HorizontalActionButton.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/10/10.
//

import UIKit
import Combine
import SnapKit

final class HorizontalActionButtonViewModel: HashableViewModel {
  let buttonBackgroundColor: UIColor = .init(hex: "#F3F3F3")
  let buttonTitle: String
  let leftImage: UIImage?
  let buttonHeight: CGFloat = 54
  
  init(buttonTitle: String, leftImage: UIImage?) {
    self.buttonTitle = buttonTitle
    self.leftImage = leftImage
  }
}

final class HorizontalActionButton: UIView {
	
	static let defaultHeight: CGFloat = 60       ///버튼 높이 54 + 위 아래 여유 6 정도

	private var containerView: UIView!
	var actionButton: UIButton!
	
//	private let buttonBackgroundColor: UIColor
//	private let buttonTitle: String
//	private let leftImage: UIImage?
//	private let buttonHeight: CGFloat
	
//	init(
//		buttonBackgroundColor: UIColor = .init(hex: "#F3F3F3"),
//		buttonTitle: String,
//		leftImage: UIImage?,
//		buttonHeight: CGFloat = 54
//	) {
//		self.buttonBackgroundColor 	= buttonBackgroundColor
//		self.buttonTitle 						= buttonTitle
//		self.leftImage 							= leftImage
//		self.buttonHeight 					= buttonHeight
//		super.init(frame: .zero)
//		configureUI()
//	}
  
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
			$0.snp.makeConstraints { $0.edges.equalToSuperview() }
		}
		
		actionButton = UIButton()
		actionButton.set {
			containerView.addSubview($0)
			$0.setTitleColor(PND.Colors.commonBlack, for: .normal)
			$0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
			$0.tintColor = PND.Colors.commonBlack
			$0.imageView?.frame = .init(x: 0, y: 0, width: 16, height: 16)
			$0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
			$0.snp.makeConstraints {
        $0.height.equalTo(Self.defaultHeight)
				$0.centerX.equalToSuperview()
				$0.leading.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
			}
		}
	}
  
  func configure(viewModel: HorizontalActionButtonViewModel) {
    
    actionButton.backgroundColor = viewModel.buttonBackgroundColor
    actionButton.setTitle(viewModel.buttonTitle, for: .normal)
    actionButton.setImage(viewModel.leftImage, for: .normal)
    actionButton.snp.updateConstraints {
      $0.height.equalTo(viewModel.buttonHeight)
    }
  }
}

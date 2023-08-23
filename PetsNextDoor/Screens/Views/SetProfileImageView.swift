//
//  SetProfileImageView.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import UIKit
import SnapKit

final class SetProfileImageView: UIView {
	
	static let defaultHeight: CGFloat = 100
	
	var containerView: UIView!
	var profileImageContainerView: UIView!
	
	private struct Constants {
    
    static let imageIcon = UIImage(systemName: "photo")
    static func imageTintColor(isImageSet: Bool) -> UIColor {
      return isImageSet
      ? PND.Colors.commonOrange
      : PND.Colors.commonBlack
    }
	}
	
	init() {
		super.init(frame: .zero)
		configureUI()
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	private func configureUI() {
		
		containerView = UIView()
		containerView.set {
			addSubview($0)
			$0.backgroundColor = PND.Colors.commonWhite
			$0.snp.makeConstraints {
				$0.edges.equalToSuperview()
			}
		}
		
		profileImageContainerView = UIView()
		profileImageContainerView.set {
			containerView.addSubview($0)
			$0.clipsToBounds = true
			$0.layer.cornerRadius = 4
			$0.backgroundColor = UIColor(hex: "F3F3F3")
			$0.snp.makeConstraints {
				$0.center.equalToSuperview()
				$0.width.height.equalTo(Self.defaultHeight)
			}
			
			let imageIcon = UIImageView()
			imageIcon.set {
				profileImageContainerView.addSubview($0)
				$0.image = Constants.imageIcon
        $0.tintColor = Constants.imageTintColor(isImageSet: false)
				$0.snp.makeConstraints {
					$0.size.equalTo(24)
					$0.center.equalToSuperview()
				}
			}
		}
	}
}

//
//  SetProfileImageView.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import UIKit
import SnapKit
import Combine 

final class SetProfileImageViewModel: HashableViewModel {
  
  @Published var selectedUserImage: UIImage? = nil
  let imageViewAlignment: Alignment
  
  init(userImage: any SingleValuePublisher<UIImage?>, imageViewAlignment: Alignment = .center) {

    self.imageViewAlignment = imageViewAlignment
    userImage.assign(to: &$selectedUserImage)
  }
  
  enum Alignment {
    case left
    case center
    case right
  }
}

final class SetProfileImageView: UIView {
	
	static let defaultHeight: CGFloat = 100
	
	var containerView: UIView!
	var profileImageContainerView: UIView!
  var profileImageView: UIImageView!
  var bottomRightPictureIconImageView: UIImageView!
  
  var image: UIImage? {
    didSet {
      guard let image else { return }
      profileImageView.image = image
      profileImageView.snp.remakeConstraints {
        $0.edges.equalToSuperview()
      }
      bottomRightPictureIconImageView.isHidden = false
    }
  }
	
	private struct Constants {
    
    static let imageIcon = UIImage(systemName: "photo")
    static func imageTintColor(isImageSet: Bool) -> UIColor {
      return isImageSet
      ? PND.Colors.commonOrange
      : PND.Colors.commonBlack
    }
	}
  
  private var subscriptions: Set<AnyCancellable> = .init()
	
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
			$0.backgroundColor = PND.Colors.gray20
			$0.snp.makeConstraints {
				$0.center.equalToSuperview()
				$0.width.height.equalTo(Self.defaultHeight)
			}
			
			profileImageView = UIImageView()
      profileImageView.set {
				profileImageContainerView.addSubview($0)
				$0.image = Constants.imageIcon
        $0.tintColor = Constants.imageTintColor(isImageSet: false)
				$0.snp.makeConstraints {
					$0.size.equalTo(24)
					$0.center.equalToSuperview()
				}
			}

      bottomRightPictureIconImageView = UIImageView()
      bottomRightPictureIconImageView.set {
        profileImageContainerView.addSubview($0)
        $0.backgroundColor = PND.Colors.commonBlack
        $0.tintColor = PND.Colors.commonOrange
        $0.image = Constants.imageIcon
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.isHidden = true
        $0.contentMode = .center
        $0.snp.makeConstraints {
          $0.size.equalTo(28)
          $0.bottom.trailing.equalToSuperview()
        }
      }
		}
	}
  
  func configure(viewModel: SetProfileImageViewModel) {
    
    viewModel.$selectedUserImage
      .receiveOnMainQueue()
      .assignNoRetain(to: \.image, on: self)
      .store(in: &subscriptions)
    
    switch viewModel.imageViewAlignment {
    case .center:
      profileImageContainerView.snp.remakeConstraints {
        $0.center.equalToSuperview()
        $0.width.height.equalTo(Self.defaultHeight)
      }
    case .left:
      profileImageContainerView.snp.remakeConstraints {
        $0.leading.equalToSuperview().inset(PND.Metrics.defaultSpacing)
        $0.width.height.equalTo(Self.defaultHeight)
      }
    case .right:
      profileImageContainerView.snp.remakeConstraints {
        $0.trailing.equalToSuperview().inset(PND.Metrics.defaultSpacing)
        $0.width.height.equalTo(Self.defaultHeight)
      }
    }
  }
}

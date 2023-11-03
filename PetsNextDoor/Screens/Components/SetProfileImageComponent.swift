//
//  SetProfileImageComponent.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import UIKit
import Combine

final class SetProfileImageComponent: Component, TouchableComponent, ValueBindable {

	typealias ContentView = SetProfileImageView
	typealias ViewModel   = SetProfileImageViewModel
	
	var subscriptions = Set<AnyCancellable>()
	
	var contentView: SetProfileImageView?
  var viewModel: SetProfileImageViewModel = .init()
	
	init() {
		
	}
	
	func createContentView() -> SetProfileImageView {
		SetProfileImageView()
	}
	
	func render(contentView: SetProfileImageView) {
		contentView.profileImageContainerView
			.onTap { [weak self] in
				guard let self else { return }
				self.onTouchAction?(self)
			}
	}
  
  func contentHeight() -> CGFloat? {
    ContentView.defaultHeight
  }
  
  //MARK: - TouchableComponent
	
	var onTouchAction: ((SetProfileImageComponent) -> Void)?
  
  func onTouch(_ action: @escaping ((SetProfileImageComponent) -> Void)) -> Self {
    self.onTouchAction = action
    return self
  }

  //MARK: - Value Observable
  
  typealias ObservingValue = UIImage?
  
  @discardableResult
  func bindValue(_ valuePublisher: PNDPublisher<ObservingValue>) -> Self {
    valuePublisher
      .receive(on: DispatchQueue.main)
      .withWeak(self)
      .sink { owner, image in
        owner?.contentView?.image = image
      }
      .store(in: &subscriptions)
    return self
  }
}

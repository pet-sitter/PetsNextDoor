//
//  SetProfileImageComponent.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import UIKit
import Combine

final class SetProfileImageComponent: Component, TouchableComponent {

	typealias ContentView = SetProfileImageView
	typealias ViewModel   = SetProfileImageViewModel
	
	var subscriptions = Set<AnyCancellable>()
	
  var viewModel: SetProfileImageViewModel
	
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
	}
	
	func createContentView() -> SetProfileImageView {
		SetProfileImageView()
	}
	
	func render(contentView: SetProfileImageView) {
    
    contentView.configure(viewModel: viewModel)
    
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
}

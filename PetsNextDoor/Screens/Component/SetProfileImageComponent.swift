//
//  SetProfileImageComponent.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import Foundation
import Combine

final class SetProfileImageComponent: Component, TouchableComponent {

	typealias ContentView = SetProfileImageView
	
	typealias Context = Void
	
	var subscriptions = Set<AnyCancellable>()
	
	var contentView: SetProfileImageView?
	var context: Void
	
	var height: CGFloat { ContentView.defaultHeight }
	
	init() {
		
	}
	
	func createContentView() -> SetProfileImageView {
		let view = SetProfileImageView()
		self.contentView = view
		return view
	}
	
	func render(contentView: SetProfileImageView, withContext context: Void) {
		
		contentView.profileImageContainerView
			.onViewTap { [weak self] in
				guard let self else { return }
				self.onTouchAction?(self)
			}
	}
	
	var onTouchAction: ((any Component) -> Void)?
	
	func onTouch(_ action: @escaping ComponentAction) -> Self {
		self.onTouchAction = action
		return self
	}
}


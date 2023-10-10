//
//  HorizontalActionButtonComponent.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/10/10.
//

import UIKit
import Combine

final class HorizontalActionButtonComponent: Component, TouchableComponent {

	var subscriptions: Set<AnyCancellable> = .init()
	
	typealias ContentView = HorizontalActionButton
	
	struct Context {
		let buttonBackgroundColor: UIColor = .init(hex: "#F3F3F3")
		let buttonTitle: String
		let leftImage: UIImage?
		let buttonHeight: CGFloat = 54
	}
	
	var contentView: HorizontalActionButton?
	var context: Context
	
	var height: CGFloat { ContentView.defaultHeight }
	
	init(context: Context) {
		self.context = context
	}
	
	func createContentView() -> ContentView {
		let view = HorizontalActionButton(
			buttonBackgroundColor: context.buttonBackgroundColor,
			buttonTitle: context.buttonTitle,
			leftImage: context.leftImage,
			buttonHeight: context.buttonHeight
		)
		self.contentView = view
		return view
	}
	
	func render(contentView: ContentView, withContext context: Context) {
		
		contentView
			.actionButton
			.controlEventPublisher(for: .touchUpInside)
			.withStrong(self)
			.sink { owner, _ in
				owner.onTouchAction?(owner)
			}
			.store(in: &subscriptions)
	}
	
	
	//MARK: - TouchableComponent
	
	private(set) var onTouchAction: ((any Component) -> Void)?
	
	func onTouch(_ action: @escaping ComponentAction) -> Self {
		self.onTouchAction = action
		return self
	}
}

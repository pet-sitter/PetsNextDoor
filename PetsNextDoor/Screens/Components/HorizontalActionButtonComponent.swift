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
	typealias ViewModel   = HorizontalActionButtonViewModel
	
	var viewModel: ViewModel
	
	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}
	
	func createContentView() -> ContentView {
    HorizontalActionButton()
	}
	
	func render(contentView: ContentView) {
    
    contentView.configure(viewModel: viewModel)
		
		contentView
			.actionButton
			.controlEventPublisher(for: .touchUpInside)
			.withStrong(self)
			.sink { owner, _ in
				owner.onTouchAction?(owner)
			}
			.store(in: &subscriptions)
	}
  
  func contentHeight() -> CGFloat? {
    ContentView.defaultHeight
  }
	
	
	//MARK: - TouchableComponent
	
	private(set) var onTouchAction: ((HorizontalActionButtonComponent) -> Void)?
  
  func onTouch(_ action: @escaping ((HorizontalActionButtonComponent) -> Void)) -> Self {
    self.onTouchAction = action
    return self
  }
}

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
  
  //MARK: - TouchableComponent
	
	var onTouchAction: ((any Component) -> Void)?
	
	func onTouch(_ action: @escaping ComponentAction) -> Self {
		self.onTouchAction = action
		return self
	}
  
  //MARK: - Value Observable
  
  typealias ObservingValue = UIImage?
  
  @discardableResult
  func bindValue(_ valuePublisher: AnyPublisher<ObservingValue, Never>) -> Self {
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

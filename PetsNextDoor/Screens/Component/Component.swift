//
//  Component.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import UIKit
import SnapKit
import Combine

protocol Component: AnyObject, IdentifierProvidable, ComponentBuildable {
	
	associatedtype ContentView: UIView
  associatedtype ViewModel: HashableViewModel
	
	var subscriptions: Set<AnyCancellable> { get set }
	
	var contentView: ContentView? { get set }
	var viewModel: ViewModel { get }
	
	func createContentView() -> ContentView
	
  func render(contentView: ContentView, withViewModel viewModel: ViewModel)
  
  func contentHeight() -> CGFloat?
}

extension Component {
  
  func buildComponents() -> [any Component] {
    return [self]
  }
}

extension Component {
  
  var identifier: String { Self.identifier }
  
  func contentHeight() -> CGFloat? { nil }

	func isHidden(_ isHiddenPublisher: PNDPublisher<Bool>) -> Self {
		isHiddenPublisher
			.sink { [weak self] isHidden in
				self?.contentView?.isHidden = isHidden
			}
			.store(in: &subscriptions)
		return self
	}
  
}


protocol TouchableComponent {
  
  associatedtype AnyComponent: Component
  
  var onTouchAction: ((AnyComponent) -> Void)? { get }
  func onTouch(_ action: @escaping ((AnyComponent) -> Void)) -> Self
}



protocol ContainsTextField {
  var onEditingChanged: (((String?, any Component)) -> Void)? { get }
  func onEditingChanged(_ action: @escaping (((String?, any Component))) -> Void) -> Self
}



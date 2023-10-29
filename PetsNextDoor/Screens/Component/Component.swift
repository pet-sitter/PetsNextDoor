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
	associatedtype Context
	
	var subscriptions: Set<AnyCancellable> { get set }
	
	var contentView: ContentView? { get set }
	var context: Context { get }
	
	func createContentView() -> ContentView
	
  func render(contentView: ContentView, withContext context: Context)
  
  
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


typealias ComponentAction = ((any Component) -> Void)

protocol TouchableComponent {
  var onTouchAction: ((any Component) -> Void)? { get }
  func onTouch(_ action: @escaping ComponentAction) -> Self
}



protocol ContainsTextField {
  var onEditingChanged: (((String?, any Component)) -> Void)? { get }
  func onEditingChanged(_ action: @escaping (((String?, any Component))) -> Void) -> Self
}



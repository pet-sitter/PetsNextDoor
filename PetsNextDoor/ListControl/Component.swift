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
	
	var viewModel: ViewModel { get }
	
	func createContentView() -> ContentView
	
  func render(contentView: ContentView)
  
  /**
   Component의 Height를 반환한다.
   - 일반적으로 UITableView delegate 메서드 중 heightForRowAt 에서 값을 반환할 때 쓰이는 값이다.
   - 따로 정의하지 않으면 기본값으로 nil이 반환된다.
   */
  func contentHeight() -> CGFloat?
}

extension Component {
  
  func buildComponents() -> [any Component] {
    return [self]
  }
}

//MARK: - Default extension methods

extension Component {
  
  var identifier: String { Self.identifier }
  
  func contentHeight() -> CGFloat? { nil }
}




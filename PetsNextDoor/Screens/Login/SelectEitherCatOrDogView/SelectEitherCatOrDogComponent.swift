//
//  SelectEitherCatOrDogComponent.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 11/29/23.
//

import Foundation
import UIKit
import SwiftUI

final class SelectEitherCatOrDogComponent: Component {
	
	typealias ContentView = UIView
	typealias ViewModel 	= SelectEitherCatOrDogViewModel
	
	var viewModel: ViewModel
	
	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}
	
	@MainActor
	func createContentView() -> ContentView {
		let config = UIHostingConfiguration { SelectEitherCatOrDogView(viewModel: viewModel) }
			.margins(.all, 0)
		return config.makeContentView()
	}
	
	func render(contentView: UIView) {

	}
	
	func contentHeight() -> CGFloat? {
		170
	}
}

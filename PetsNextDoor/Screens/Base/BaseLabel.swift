//
//  BaseLabel.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/10/10.
//

import UIKit
import Combine

class BaseLabel: UILabel {
	
	private var subscriptions = Set<AnyCancellable>()
	
	init() {
		super.init(frame: .zero)
		configureUI()
	}
	
	@available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
	
	convenience init(textValue: PNDPublisher<String>) {
		self.init()
		textValue
			.compactMap { $0 }
			.sink { [weak self] textValue in
				self?.text = textValue
			}
			.store(in: &subscriptions)
	}
	
	private func configureUI() {
		
	}
}

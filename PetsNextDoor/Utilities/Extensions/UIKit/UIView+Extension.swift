//
//  UIView+Extension.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import UIKit

extension UIView {
	
	func onViewTap(_ action : @escaping () -> Void) {
		let tap = PNDTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
		tap.action = action
		tap.numberOfTapsRequired = 1
		self.addGestureRecognizer(tap)
		self.isUserInteractionEnabled = true
	}
	
	@objc func handleTap(_ sender: PNDTapGestureRecognizer) {
		sender.action!()
	}
}

class PNDTapGestureRecognizer: UITapGestureRecognizer {
	var action : (() -> Void)? = nil
}

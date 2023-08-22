//
//  BaseTableView.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/08/22.
//

import UIKit

class BaseTableView: UITableView {
	
	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: frame, style: style)
		separatorStyle = .none
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//
//  NavigationTitleBarView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/01.
//

//MARK: - 홈화면 좌측 상단 NavigationBar에 사용되는 View ()

import UIKit
import SnapKit

struct NavigationTitleBarViewModel: HashableViewModel {
  let titleString: String
  let isUnderlineViewHidden: Bool
}

final class NavigationTitleBarView: UIView {
  
  private var containerView: UIView!
  private var titleLabel: UILabel!
  private var underlineView: UIView!
  
  let viewModel: NavigationTitleBarViewModel
  
  init(viewModel: NavigationTitleBarViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    containerView.set {
      addSubview($0)
      $0.backgroundColor = .clear
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    underlineView = UIView()
    underlineView.set {
      containerView.addSubview($0)
      $0.backgroundColor = UIColor(hex: "#FFECD6")
      $0.snp.makeConstraints {
        $0.leading.equalToSuperview().offset(-3)
        $0.trailing.equalToSuperview().offset(3)
        $0.height.equalTo(10)
        $0.bottom.equalToSuperview()
      }
      $0.isHidden = viewModel.isUnderlineViewHidden
    }
    
    titleLabel = UILabel()
    titleLabel.set {
      containerView.addSubview($0)
      $0.font = .systemFont(ofSize: 24, weight: .bold)
      $0.text = viewModel.titleString
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
  }
  
  func configureDistrictName(_ districtName: String) {
    titleLabel.text = districtName
  }
}

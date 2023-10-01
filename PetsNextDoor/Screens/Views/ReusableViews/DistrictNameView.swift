//
//  DistrictNameView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/01.
//

//MARK: - 홈화면 좌측 상단 NavigationBar에 사용되는 동네 이름 나타내는 View

import UIKit
import SnapKit

final class DistrictNameView: UIView {
  
  private var containerView: UIView!
  private var districtNameLabel: UILabel!
  private var underlineView: UIView!
  
  init() {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func configureUI() {
    
    containerView = UIView()
    containerView.set {
      addSubview($0)
      $0.backgroundColor = .clear
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }

    
    underlineView = UIView()
    underlineView.set {
      addSubview($0)
      $0.backgroundColor = UIColor(hex: "#FFECD6")
      $0.snp.makeConstraints {
        $0.leading.equalToSuperview().offset(-3)
        $0.trailing.equalToSuperview().offset(3)
        $0.height.equalTo(10)
        $0.bottom.equalToSuperview()
      }
    }
    
    
    districtNameLabel = UILabel()
    districtNameLabel.set {
      addSubview($0)
      $0.font = .systemFont(ofSize: 24, weight: .bold)
      $0.text = "이웃집멍냥이네"
      $0.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
    
  }
  
  func configureDistrictName(_ districtName: String) {
    
  }
}

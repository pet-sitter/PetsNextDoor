//
//  MeetingCardView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/16.
//

import UIKit
import SnapKit

struct MeetingCardViewModel: HashableViewModel {
  
  
}

final class MeetingCardView: UIView, HeightProvidable {
  
  static var defaultHeight: CGFloat { 112 }
  
  private var containerView: UIView!
  private var mainImageView: UIImageView!
  
  private var containerStackView: UIStackView!
  
  private var titleLabel: UILabel!
  
  
  
}

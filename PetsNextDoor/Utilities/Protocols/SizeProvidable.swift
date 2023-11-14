//
//  HeightProvidable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/08.
//
import UIKit

protocol SizeProvidable {
  
  static var defaultSize: CGSize { get }
  var defaultSize: CGSize { get }
}

extension SizeProvidable {
  var defaultSize: CGSize { Self.defaultSize }
}


protocol HeightProvidable {
  
  static var defaultHeight: CGFloat { get }
  var defaultHeight: CGFloat { get }
}

extension HeightProvidable {
  var defaultHeight: CGFloat { Self.defaultHeight }
}

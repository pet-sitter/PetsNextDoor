//
//  Kingfisher+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 8/19/24.
//

import Foundation
import Kingfisher
import SwiftUI 

extension KFImage {
  
  func centerCropImage(width: CGFloat, height: CGFloat) -> some View {
    self
      .resizable()
      .scaledToFill()
      .frame(width: width, height: height)
      .clipped()
      .contentShape(Rectangle())
  }
  
}

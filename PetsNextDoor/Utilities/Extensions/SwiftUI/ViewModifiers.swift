//
//  ViewModifiers.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/18.
//

import SwiftUI

struct HeaderTitleModifier: ViewModifier {
  
  func body(content: Content) -> some View {
    content
      .font(.system(size: 20, weight: .bold))
      .multilineTextAlignment(.leading)
      .padding(.leading, 20)
  }
}

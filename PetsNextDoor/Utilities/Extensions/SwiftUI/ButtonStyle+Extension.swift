//
//  ButtonStyle+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 9/2/24.
//

import SwiftUI


struct ScaleEffectButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.97 : 1)
  }
}

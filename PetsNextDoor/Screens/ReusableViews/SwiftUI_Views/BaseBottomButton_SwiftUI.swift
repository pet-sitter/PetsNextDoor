//
//  BaseBottomButton_SwiftUI.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI

struct BaseBottomButton_SwiftUI: View {
  
  var isEnabledColor: Color = PND.Colors.commonBlack.asColor
  let title: String
  @Binding var isEnabled: Bool
  @State var isDisabled: Bool = false
  
  var body: some View {
    RoundedRectangle(cornerRadius: 4)
      .padding(.horizontal, PND.Metrics.defaultSpacing)
      .frame(height: CGFloat(60))
      .foregroundStyle(
        isEnabled ? isEnabledColor : PND.Colors.gray30.asColor
      )
      .disabled(isEnabled ? false : true)
      .overlay(
        Text(title)
          .font(.system(size: 20, weight: .bold))
          .foregroundStyle(.white)
      )
  }
}

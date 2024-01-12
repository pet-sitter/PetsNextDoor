//
//  CheckBoxView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI

struct CheckBoxView: View {
  
  @Binding var isSelected: Bool

  var body: some View {
    Button(action: {
      isSelected.toggle()
    }, label: {
      Image(isSelected ? R.image.checkbox_selected : R.image.checkboxUnselected)
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
    })
  }
}

#Preview {
  CheckBoxView(isSelected: .constant(false))
}

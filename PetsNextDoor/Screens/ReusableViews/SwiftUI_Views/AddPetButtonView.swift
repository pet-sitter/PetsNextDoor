//
//  AddPetButton.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/15.
//

import SwiftUI

struct AddPetButtonView: View {
  
  var onTapGesture: (() -> Void)?
  
  var body: some View {
    Button {
      onTapGesture?()
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 4)
          .frame(height: 54)
          .padding(.horizontal, PND.Metrics.defaultSpacing)
          .foregroundStyle(PND.Colors.gray20.asColor)
          .contentShape(Rectangle())
        
        HStack(spacing: 5) {
          Image(systemName: "plus")
            .frame(width: 16, height: 16)
          Text("반려동물 추가하기")
            .font(.system(size: 16))
        }
        .foregroundStyle(PND.DS.commonBlack)
      }
    }
  }
}


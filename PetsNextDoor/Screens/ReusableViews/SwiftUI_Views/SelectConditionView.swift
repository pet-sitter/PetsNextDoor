//
//  SelectConditionView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI

struct SelectConditionView<RightContent: View>: View {
  
  let leftImageName: String?
  let conditionTitle: String
  
  @ViewBuilder
  let rightContentView: () -> RightContent
  
  var body: some View {
    HStack {
      
      if let leftImageName {
        Image(leftImageName)
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
      }

      Spacer().frame(width: 5)
      
      Text(conditionTitle)
        .font(.system(size: 20, weight: .bold))
        .lineLimit(1)
      
      Spacer()
      
      rightContentView()
    }
    .padding(.horizontal, 20)
  }
}




#Preview {
  SelectConditionView(
    leftImageName: nil,
    conditionTitle: "성별",
    rightContentView: {
      TextField("원", value: .constant(0), format: .number)
        .keyboardType(.numberPad)
        .font(.system(size: 20, weight: .medium))
        .padding(8)
        .frame(width: 126)
        .multilineTextAlignment(.trailing)
        .background(PND.Colors.gray20.asColor)
        .cornerRadius(4)
    }
  )
}



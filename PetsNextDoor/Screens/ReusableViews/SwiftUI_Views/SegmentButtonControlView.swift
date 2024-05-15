//
//  SegmentButtonControlView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI

struct SegmentButtonControlView: View {
  
  @Binding var selectedIndex: Int
  let buttonTitles: [String]
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(0..<buttonTitles.count, id: \.self) { index in
        segmentButtonView(title: buttonTitles[index], index: index)
      }
    }
  }
  
  func segmentButtonView(title: String, index: Int) -> some View {
    Button(action: {
      withAnimation {
        selectedIndex = index
      }
    }, label: {
      Text(title)
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(
          index == selectedIndex
          ? PND.DS.commonWhite
          : PND.DS.gray50
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(
          index == selectedIndex
          ? PND.DS.commonBlack
          : PND.DS.gray20
        )
        .clipShape(RoundedRectangle(cornerRadius: 4))
    })
  }
}


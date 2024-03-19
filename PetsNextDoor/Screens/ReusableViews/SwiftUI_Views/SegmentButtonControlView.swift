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
      selectedIndex = index
    }, label: {
      Text(title)
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(
          index == selectedIndex
          ? PND.Colors.commonWhite.asColor
          : PND.Colors.gray30.asColor
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(
          index == selectedIndex
          ? PND.Colors.commonBlack.asColor
          : PND.Colors.commonWhite.asColor
        )
        .overlay(
          RoundedRectangle(cornerRadius: 4)
            .inset(by: 0.5)
            .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 1)
            .opacity(index == selectedIndex ? 0 : 1)
        )
        .cornerRadius(4)
        .frame(minWidth: 80, minHeight: 30)
    })
  }
}


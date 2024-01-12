//
//  SegmentControlView_SwiftUI.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI

struct SegmentControlView_SwiftUI: View {
  
  @Binding var selectedIndex: Int
  let segmentTitles: [String]
  
  var body: some View {
    HStack(spacing: 12) {
      ForEach(0..<segmentTitles.count, id: \.self) { index in
        segmentTitleView(title: segmentTitles[index], index: index)
        
      }
    }
  }
  
  func segmentTitleView(title: String, index: Int) -> some View {
    Button(action: {
      selectedIndex = index
    }, label: {
      Text(title)
        .font(.system(size: 20, weight: index == selectedIndex ? .semibold : .medium))
        .foregroundStyle(
          index == selectedIndex
          ? PND.Colors.primary.asColor
          : PND.Colors.gray30.asColor
        )
    })
  }
}

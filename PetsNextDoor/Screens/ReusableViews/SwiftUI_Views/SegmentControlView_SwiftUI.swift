//
//  SegmentControlView_SwiftUI.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI


// 타이틀만 있는 버전
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
        .font(.system(size: 20, weight: .bold))
        .foregroundStyle(
          index == selectedIndex
          ? PND.Colors.primary.asColor
          : PND.Colors.gray30.asColor
        )
    })
  }
}

// 직사각형 버전

struct RectangleSegmentControlView: View {
  
  @Binding var selectedIndex: Int
  let segmentTitles: [String]
  
  var body: some View {
    HStack(spacing: 4) {
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
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(
          index == selectedIndex
          ? PND.Colors.commonWhite.asColor
          : PND.Colors.gray50.asColor
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(
          index == selectedIndex
          ? PND.Colors.commonBlack.asColor
          : PND.Colors.gray20.asColor
        )
        .clipShape(RoundedRectangle(cornerRadius: 4))
    })
  }
}

#Preview {
  SegmentControlView_SwiftUI(selectedIndex: .constant(0), segmentTitles: ["둘러보기", "내 모임"])
}

//
//  PageControl.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/02/26.
//

import SwiftUI

struct PageControl: View {
  
  let numberOfPages: Int
  @Binding var currentIndex: Int
  
  
  private let circleSize: CGFloat = 6
  private let circleSpacing: CGFloat = 12
  
  private let primaryColor = Color.black
  private let secondaryColor = Color.black.opacity(0.35)
  
  private let smallScale: CGFloat = 0.6
  
  
  var body: some View {
    HStack(spacing: circleSpacing) {
      ForEach(0..<numberOfPages, id: \.self) { index in
        if shouldShowIndex(index) {
          Circle()
            .fill(currentIndex == index ? primaryColor : secondaryColor) 
            .scaleEffect(currentIndex == index ? 1 : smallScale)
            .frame(width: circleSize, height: circleSize)
            .transition(AnyTransition.opacity.combined(with: .scale))
            .id(index)
        }
      }
    }
  }

  func shouldShowIndex(_ index: Int) -> Bool {
    ((currentIndex - 1)...(currentIndex + 1)).contains(index)
  }
}

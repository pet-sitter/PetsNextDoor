//
//  DefaultSpacer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/15.
//

import SwiftUI

struct DefaultSpacer: View {
  
  enum Axis {
    case vertical
    case horizontal
  }
  
  private let axis: Axis
  
  init(axis: Axis) {
    self.axis = axis
  }
  
  var body: some View {
    if axis == .horizontal {
      Spacer().frame(width: PND.Metrics.defaultSpacing)
    } else {
      Spacer().frame(height: PND.Metrics.defaultSpacing)
    }
  }
}


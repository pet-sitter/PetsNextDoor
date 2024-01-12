//
//  GesturePassthroughView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import UIKit

class GesturePassthroughView: UIView {
  
  var shouldGesturePassthrough: Bool = true
  
  weak var outsideOfBoundsView: UIView?
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    
    guard shouldGesturePassthrough else { return super.hitTest(point, with: event) }
    
    if let outSider = outsideOfBoundsView, (outSider.isHidden == false && outSider.alpha > 0) {
      let pointForTargetView = outSider.convert(point, from: self)
      if outSider.bounds.contains(pointForTargetView) {
        return outSider.hitTest(pointForTargetView, with: event)
      }
      return super.hitTest(point, with: event)
    } else {
      let view = super.hitTest(point, with: event)
      guard view != self else {
        return nil
      }
      return view
    }
  }
}

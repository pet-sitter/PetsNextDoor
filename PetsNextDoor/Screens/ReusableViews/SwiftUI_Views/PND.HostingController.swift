//
//  PNDHostingController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/17.
//

import UIKit
import SwiftUI

extension PND {
  
  final class HostingController<Content>: UIHostingController<AnyView> where Content: View {
    
    init(rootView: Content, shouldShowNavigationBar: Bool = false) {
      super.init(rootView: AnyView(rootView.navigationBarHidden(!shouldShowNavigationBar)))
      navigationController?.isNavigationBarHidden = true
    }
    
    required dynamic init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

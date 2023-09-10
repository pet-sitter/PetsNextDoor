//
//  CommunityViewController.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/27.
//

import UIKit
import Combine
import SnapKit
import ComposableArchitecture

final class CommunityViewController: BaseViewController {
  
  typealias Feature = CommunityFeature
  typealias State   = CommunityFeature.State
  typealias Action  = CommunityFeature.Action
  
  private let viewStore: ViewStoreOf<Feature>
  
  init(store: some StoreOf<Feature>) {
    self.viewStore = ViewStore(store, observe: { $0 })
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemTeal
    
    
  }
  
  override func configureUI() {
    super.configureUI()
    
    
  }
  

  
}

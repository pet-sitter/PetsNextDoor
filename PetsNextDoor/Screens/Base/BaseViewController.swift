//
//  BaseViewController.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/07/04.
//

import UIKit
import Combine

protocol SectionViewProvidable {
  
  /**
   하나 또는 여러 개의 Section으로 구성되어 있는 뷰를 그려야 하는 경우 제공하는 인스턴스
   - 하나의 Section은 UITableView의 Section과 동일한 역할 수행 
   */
  @SectionBuilder
  var sectionView: SectionsBuildable { get }
}

protocol ComponentViewProvidable {
  
  /**
   Component들로만 이루어져있는 뷰를 그려야 하는 경우 제공하는 인스턴스
   */
  @ComponentBuilder
  var componentView: ComponentBuildable { get }
}

protocol RenderableViewProvidable: SectionViewProvidable, ComponentViewProvidable {}

extension RenderableViewProvidable {
  var sectionView: SectionsBuildable    { SectionBuilder() }
  var componentView: ComponentBuildable { ComponentBuilder() }
}



class BaseViewController: UIViewController, LoadingIndicatorInsertable {
  
  var loadingIndicator: LoadingIndicatorView = .init()
  
  var subscriptions = Set<AnyCancellable>()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable) required init?(coder: NSCoder) { fatalError("Not implemented") }
  
  deinit {
    loadingIndicator.stopAnimating()
    print("✅ DEINIT: \(String(describing: Self.self))")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  func configureUI() {
		view.backgroundColor = PND.Colors.commonWhite
  }
    
  func configureTopLeftTitle(_ title: String) {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: nil)
  }
}





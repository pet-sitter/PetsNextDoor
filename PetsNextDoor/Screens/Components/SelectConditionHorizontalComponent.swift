//
//  SelectConditionHorizontalComponent.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/08.
//

import Foundation

final class SelectConditionHorizontalComponent: Component, ContainsSegments, ContainsTextField {

  typealias ContentView = SelectConditionHorizontalView
  typealias ViewModel   = SelectConditionViewModel
  
  var viewModel: ViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  func createContentView() -> SelectConditionHorizontalView {
    SelectConditionHorizontalView()
  }
  
  func render(contentView: SelectConditionHorizontalView) {
    contentView.configure(viewModel: viewModel)
    
    
    if let textFieldView = viewModel.rightConditionView as? BaseFilledTextField {
      
      textFieldView.onTextChange = { [weak self] text in
        guard let self else { return }
        onEditingChanged?( (text, self) )
      }
    }
  }
  
  func contentHeight() -> CGFloat? {
    ContentView.defaultHeight
  }
  
  //MARK: - ContainsSegments
  
  private(set) var onSegmentChange: ((Int) -> Void)?
  
  func onSegmentChange(_ action: ((Int) -> Void)?) -> Self {
    self.onSegmentChange = action
    return self
  }
  
  //MARK: - ContainsTextField
  
  private(set) var onEditingChanged: (( (String?, SelectConditionHorizontalComponent) ) -> Void)?
  
  func onEditingChanged(_ action: @escaping (((String?, SelectConditionHorizontalComponent))) -> Void) -> Self {
    self.onEditingChanged = action
    return self
  }
}



//
//  SelectDateHorizontalView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/08.
//

import SwiftUI

final class SelectDateHorizontalViewModel: ObservableObject, HashableViewModel {
  
  var onDateChange: ((Date) -> Void)?
  
  @Published var date = Date() { didSet { onDateChange?(date) }}
}

struct SelectDateHorizontalView: View {
    
  @StateObject var viewModel: SelectDateHorizontalViewModel
  
  var body: some View {
    HStack {
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
      
      Image(systemName: "calendar.circle.fill")
        .frame(width: 24, height: 24)
        .tint(.black)
      
      Spacer().frame(width: 5)
      
      Text("날짜")
        .font(.system(size: 20, weight: .bold))
        .tint(PND.Colors.commonBlack.asColor)
      
      Spacer()
      
      DatePicker(selection: $viewModel.date, displayedComponents: .date) { }
        
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
    }
  }
}

//#Preview {
//  SelectDateHorizontalView()
//}


final class SelectDateHorizontalComponent: Component {
  
  typealias ContentView = UIView
  typealias ViewModel   = SelectDateHorizontalViewModel
  
  var viewModel: SelectDateHorizontalViewModel
  
  init(viewModel: SelectDateHorizontalViewModel) {
    self.viewModel = viewModel
  }
  
  @MainActor 
  func createContentView() -> ContentView {
    let config = UIHostingConfiguration { SelectDateHorizontalView(viewModel: self.viewModel) }
      .margins(.all, 0)
    return config.makeContentView()
  }
  
  func render(contentView: ContentView) {
    viewModel.onDateChange = { [weak self] date in
      self?.onDateChange?(date)
    }
  }
  
  private var onDateChange: ((Date) -> Void)?
  
  func onDateChange(_ action: @escaping ((Date) -> Void)) -> Self {
    self.onDateChange = action
    return self
  }
}

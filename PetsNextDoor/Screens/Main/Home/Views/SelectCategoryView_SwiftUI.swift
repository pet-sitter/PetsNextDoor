//
//  SelectCategoryView_SwiftUI.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/16.
//

import SwiftUI

struct SelectCategoryView_SwiftUI: View {
  
  enum Category: CaseIterable {
    case onlyDogs
    case onlyCats
    case doesntMatter
    
    var buttonTitle: String {
      switch self {
      case .onlyDogs:     "강아지만"
      case .onlyCats:     "고양이만"
      case .doesntMatter: "상관없음"
      }
    }
  }
  
  @Binding var selectedCategory: Category
  
  
  var body: some View {
    HStack {
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
      
      Text("최신순")
        .font(.system(size: 16, weight: .bold))
      
      Spacer().frame(width: 4)
      
      Image(R.image.icon_arr_down)
        .resizable()
        .frame(width: 16, height: 16)
      
      Spacer()
      
      ForEach(Category.allCases, id: \.self) { category in
      }
      
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
      
    }
  }
  
  func checkableButton(category: Category) -> some View {
    Button(action: {
      selectedCategory = category
    }, label: {
      HStack(spacing: 2) {
        Image(R.image.icon_check)
          .resizable()
          .frame(width: 12, height: 12)
        
        Text(category.buttonTitle)
          .font(.system(size: 12, weight: .semibold))
          .foregroundStyle(PND.Colors.commonBlack.asColor)
        
      }
    })
  }
}

#Preview {
  SelectCategoryView_SwiftUI(selectedCategory: .constant(.onlyDogs))
}

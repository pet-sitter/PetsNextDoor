//
//  SelectCategoryView_SwiftUI.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/16.
//

import SwiftUI

struct SelectCategoryView_SwiftUI: View {

  @Binding var filterOption: PND.FilterType
  @Binding var sortOption: PND.SortOption

  var body: some View {
    HStack {
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
      
      Menu {
        Button {
          sortOption = .newest
        } label: {
          HStack {
            Text(PND.SortOption.newest.description)
            Spacer()
            if sortOption == .newest {
              Image(systemName: "checkmark")
            }
          }
        }
        
        Button {
          sortOption = .deadline
        } label: {
          HStack {
            Text(PND.SortOption.deadline.description)
            Spacer()
            if sortOption == .deadline {
              Image(systemName: "checkmark")
            }
          }
        }

      } label: {
        Text(sortOption.description)
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(PND.Colors.commonBlack.asColor)
      }

      
      Spacer().frame(width: 4)
      
      Image(R.image.icon_arr_down)
        .resizable()
        .frame(width: 16, height: 16)
      
      Spacer()
      
      ForEach(PND.FilterType.allCases, id: \.self) { filter in
        checkableButton(animalFilter: filter)
      }
      
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
      
    }
  }
  
  func checkableButton(animalFilter: PND.FilterType) -> some View {
    return Button(action: {
      filterOption = animalFilter
    }, label: {
      HStack(spacing: 2) {
        if filterOption == animalFilter {
          Image(R.image.icon_check)
            .resizable()
            .frame(width: 12, height: 12)
        }
        
        Text(animalFilter.description)
          .font(.system(size: 12, weight: filterOption == animalFilter ? .semibold : .regular))
          .foregroundStyle(
            filterOption == animalFilter
            ? PND.Colors.commonBlack.asColor
            : UIColor(hex: "#9E9E9E").asColor
          )
      }
    })
  }
}

#Preview {
  SelectCategoryView_SwiftUI(filterOption: .constant(.onlyCats), sortOption: .constant(.newest))
}

//
//  CommunityView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/17.
//

import SwiftUI
import ComposableArchitecture

struct CommunityView: View {
  
  let store: StoreOf<CommunityFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationStack {
        VStack(alignment: .leading) {
          
          Spacer().frame(height: 12)
          
          SegmentControlView_SwiftUI(
            selectedIndex: viewStore.binding(
              get: \.tabIndex,
              send: { .onTabIndexChange($0)}
            ),
            segmentTitles: ["둘러보기", "내 모임"]
          )
          .padding(.leading, PND.Metrics.defaultSpacing)
          
          
          Rectangle()
            .fill(PND.Colors.gray10.asColor)
            .frame(height: 20)
          
//          SelectCategoryView_SwiftUI(selectedCategory: viewStore.binding(
//            get: \.selectedCategory,
//            send: { .onSelectedCategoryChange($0)}
//          ))
          
          ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
              ForEach(viewStore.meetingCardCellViewModels, id: \.id) { vm in
                MeetingCardView(viewModel: vm)
              }
            }
          }
        }
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            HStack {
              Image(.iconPinNavBar)
                .frame(width: 24, height: 24)
              
              ZStack {
                Rectangle()
                  .fill(PND.Colors.lightGreen.asColor)
                  .frame(height: 10)
                  .offset(y: 10)
                
                Text("중곡동")
                  .font(.system(size: 24, weight: .bold))
              }
            }
          }
          
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
//              viewStore.send(.didTapWritePostIcon)
            }, label: {
              Image(systemName: "plus")
                .resizable()
                .frame(width: 24, height: 24)
                .tint(PND.Colors.commonBlack.asColor)
            })
          }
        }
      }
    }
  }
}

//#Preview {
//    CommunityView()
//}

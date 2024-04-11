//
//  HomeView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/17.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
  
  let store: StoreOf<HomeFeature>
  
  @EnvironmentObject var router: Router
  
  @State private var tabBarIsHidden: Bool = false
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        
        Spacer().frame(height: 12)
        
        SegmentControlView_SwiftUI(
          
          selectedIndex: viewStore.binding(
            get: \.tabIndex,
            send: { .view(.onTabIndexChange($0)) }
          ),
          segmentTitles: ["돌봄급구", "돌봄메이트"]
        )
        .padding(.leading, PND.Metrics.defaultSpacing)
        
        ScrollView(.vertical) {
          
          Rectangle()
            .fill(PND.Colors.gray10.asColor)
            .frame(height: 20)
          
          SelectCategoryView_SwiftUI(
            selectedCategory: viewStore.binding(
              get: \.selectedCategory,
              send: { .view(.onSelectedCategoryChange($0)) }
            ),
            filterOption: viewStore.binding(
              get: \.selectedFilterOption,
              send: { .view(.onSelectedFilterOptionChange($0)) }
            )
          )
          
          if viewStore.isLoadingInitialData {
            ProgressView()
              .frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              
          } else {
            LazyVStack(spacing: 0) {
              ForEach(viewStore.urgentPostCardCellViewModels, id: \.postId) { vm in
                UrgentPostCardView_SwiftUI(viewModel: vm)
                  .onTapGesture {
                    viewStore.send(.view(.onUrgentPostTap(postId: vm.postId)))
                    setTabBarIsHidden(to: true)
                  }
              }
            }
          }
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          HStack {
            Image(R.image.icon_pin_nav_bar)
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
            viewStore.send(.view(.onSelectWritePostIcon))
            setTabBarIsHidden(to: true)
          }, label: {
            Image(R.image.icon_pen)
              .resizable()
              .frame(width: 24, height: 24)
              .tint(PND.Colors.commonBlack.asColor)
          })
        }
      }
      .onAppear {
        viewStore.send(.view(.onAppear))
        setTabBarIsHidden(to: false)
      }
//      .toolbar(tabBarIsHidden ? .hidden : .visible, for: .tabBar)
    }
  }
  
  private func setTabBarIsHidden(to isHidden: Bool) {
    withAnimation(.snappy) {
      tabBarIsHidden = isHidden
    }
  }
}

#Preview {
  HomeView(store: .init(initialState: .init(), reducer: { HomeFeature() }))
}

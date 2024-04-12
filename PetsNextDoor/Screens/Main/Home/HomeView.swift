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
  
  @State private var tabBarIsHidden: Bool = false
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        VStack(alignment: .leading) {

          topNavigationBarView

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
            
            VStack(spacing: 0) {
              
              RoundedRectangle(cornerRadius: 4)
                .frame(height: 40)
                .padding(.horizontal, PND.Metrics.defaultSpacing)
                .foregroundStyle(PND.DS.gray20)
                .overlay(alignment: .leading) {
                  HStack(spacing: 8) {
                    Image(R.image.icon_search)
                      .size(16)
                    
                    Text("돌봄요청글을 검색해보세요")
                      .foregroundStyle(UIColor(hex: "#9E9E9E").asColor)
                      .font(.system(size: 16))
                  }
                  .padding(.leading, PND.Metrics.defaultSpacing + 12)
                }
              
              Rectangle()
                .fill(.white)
                .frame(height: 5)
            }
            
            Rectangle()
              .fill(PND.Colors.gray10.asColor)
              .frame(height: 16)
            
            Rectangle()
              .fill(.white)
              .frame(height: 5)
            
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
        
        bottomTrailingFloatingButton

      }
      .onAppear {
        viewStore.send(.view(.onAppear))
        setTabBarIsHidden(to: false)
      }
//      .toolbar(tabBarIsHidden ? .hidden : .visible, for: .tabBar)
    }
  }
  
  private var topNavigationBarView: some View {
    HStack {
      Spacer().frame(width: PND.Metrics.defaultSpacing)
      HStack {
        Image(R.image.icon_pin_nav_bar)
          .frame(width: 24, height: 24)
        
        Text("중곡동")
          .font(.system(size: 22, weight: .bold))
          .background(alignment: .bottom) {
            Rectangle()
              .fill(PND.Colors.lightGreen.asColor)
              .frame(height: 10)
          }
      }
    
      Spacer()
      
      Button(action: {
        store.send(.view(.onSelectWritePostIcon))
        setTabBarIsHidden(to: true)
      }, label: {
        Image(R.image.icon_bell)
          .resizable()
          .frame(width: 24, height: 24)
          .tint(PND.Colors.commonBlack.asColor)
      })
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
    }
  }
  
  private var bottomTrailingFloatingButton: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Button {
          store.send(.view(.onSelectWritePostIcon))
        } label: {
          Circle()
            .foregroundStyle(PND.DS.commonBlack)
            .frame(width: 60, height: 60)
            .overlay(alignment: .center) {
              Image(systemName: "plus")
                .frame(width: 32, height: 32)
                .foregroundStyle(PND.DS.primary)
            }
            .offset(x: -17, y: -19)
        }
      }
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

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
  
  @Namespace var sd
  
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
            LazyVStack(spacing: 0) {
              
              VStack(spacing: 0) {
                
                searchView
                
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
                filterOption: viewStore.binding(
                  get: \.selectedFilterOption,
                  send: { .view(.onSelectedFilterOptionChange($0))}
                ),
                sortOption: viewStore.binding(
                  get: \.selectedSortOption,
                  send: { .view(.onSelectedSortOptionChange($0))}
                )
              )
       
              if viewStore.isLoadingInitialData {
                HStack {
                  Spacer()
                  ProgressView()
                    .id(UUID())
                  Spacer()
                }
                
              } else {
                if let emptyContentMessage = viewStore.state.emptyContentMessage {
                  VStack {
                    Spacer()
                    HStack {
                      Spacer()
                      Text(emptyContentMessage)
                        .multilineTextAlignment(.center)
                        .frame(width: 150, height: 150)
                      Spacer()
                    }
                    Spacer()
                  }
                  
                } else {
                  ForEach(viewStore.urgentPostCardCellViewModels, id: \.postId) { vm in
                    UrgentPostCardView_SwiftUI(viewModel: vm)
                      .onTapGesture {
                        viewStore.send(.view(.onUrgentPostTap(postId: vm.postId)))
                        setTabBarIsHidden(to: true)
                      }
                  }
                  .animation(.easeInOut, value: viewStore.state.urgentPostCardCellViewModels)
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
      .alert(
        "돌봄 서비스를 이용하기 위해서는 반려동물 등록이 필요해요!",
        isPresented: viewStore.binding(
          get: \.isPetRegistrationNeededAlertPresented,
          send: { .internal(.setIsPetRegistrationNeededAlertPresented($0)) }
        )
      ) {
        Button("OK", role: .cancel) {
          viewStore.send(.view(.onPetRegistrationAlertOkButtonTap))
        }
      }
    }
  }
  
  @ViewBuilder
  private var topNavigationBarView: some View {
    HStack {
      Spacer().frame(width: PND.Metrics.defaultSpacing)
      HStack {
        Image(.iconPinNavBar)
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
        store.send(.view(.onSelectNotificationsIcon))
        setTabBarIsHidden(to: true)
      }, label: {
        Image(.iconBell)
          .resizable()
          .frame(width: 24, height: 24)
          .tint(PND.Colors.commonBlack.asColor)
      })
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
    }
  }
  
  private var searchView: some View {
    RoundedRectangle(cornerRadius: 4)
      .frame(height: 40)
      .padding(.horizontal, PND.Metrics.defaultSpacing)
      .foregroundStyle(PND.DS.gray20)
      .overlay(alignment: .leading) {
        HStack(spacing: 8) {
          Image(.iconSearch)
            .size(16)
          
          Text("돌봄요청글을 검색해보세요")
            .foregroundStyle(UIColor(hex: "#9E9E9E").asColor)
            .font(.system(size: 16))
        }
        .padding(.leading, PND.Metrics.defaultSpacing + 12)
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
  
  private var emptyView: some View {
    VStack {
      Spacer()
      Text("작성된 돌봄 급구 글이 없습니다!\n첫 글을 작성해보세요!")
        .multilineTextAlignment(.center)
        .font(.system(size: 14, weight: .semibold))
      Spacer()
    }
  }
  
  private func setTabBarIsHidden(to isHidden: Bool) {
    withAnimation(.snappy) {
      tabBarIsHidden = isHidden
    }
  }
}

//#Preview {
//  HomeView(store: .init(initialState: .init(), reducer: { HomeFeature() }))
//}

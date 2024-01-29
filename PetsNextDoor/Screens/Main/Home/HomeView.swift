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
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        
        Spacer().frame(height: 12)
        
        SegmentControlView_SwiftUI(
          selectedIndex: viewStore.binding(
            get: \.tabIndex,
            send: { .onTabIndexChange($0)}
          ),
          segmentTitles: ["돌봄급구", "돌봄메이트"]
        )
        .padding(.leading, PND.Metrics.defaultSpacing)
        
        ScrollView(.vertical) {
          
          Rectangle()
            .fill(PND.Colors.gray10.asColor)
            .frame(height: 20)
          
          SelectCategoryView_SwiftUI(selectedCategory: viewStore.binding(
            get: \.selectedCategory,
            send: { .onSelectedCategoryChange($0)}
          ))
          
          if viewStore.isLoadingInitialData {
            ProgressView()
              .frame(maxWidth: .infinity, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              
          } else {
            LazyVStack(spacing: 0) {
              ForEach(viewStore.urgentPostCardCellViewModels, id: \.id) { vm in
                UrgentPostCardView_SwiftUI(viewModel: vm)
                  .onTapGesture {
                    router.pushScreen(to: UrgentPostDetailFeature.State())
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
            router.pushScreen(to: SelectPetFeature.State())
          }, label: {
            Image(R.image.icon_pen)
              .resizable()
              .frame(width: 24, height: 24)
              .tint(PND.Colors.commonBlack.asColor)
          })
        }
      }
      .navigationDestination(for: UrgentPostDetailFeature.State.self) { state in
        UrgentPostDetailView(
          store: .init(
            initialState: state,
            reducer: { UrgentPostDetailFeature() }
          )
        )
        .toolbar(.hidden, for: .tabBar)
      }
      .navigationDestination(for: SelectPetFeature.State.self) { selectPetState in
        SelectPetListView(
          store: .init(
            initialState: selectPetState,
            reducer: { SelectPetFeature() }
          )
        )
        .toolbar(.hidden, for: .tabBar)
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

#Preview {
  HomeView(store: .init(initialState: .init(), reducer: { HomeFeature() }))
}

//
//  MainHomeView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 9/6/24.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct MainHomeFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    var tabIndex: Int = 0
    var sortOption: PND.SortOption = .newest // 최신순, 마감순
    
    var eventCardVMs: [EventCardView.ViewModel] = [
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "2024.03.21 금요일 20:00",
        eventTitle: "훈련사님과 함께하는 멍BTI 진단하기",
        eventDescription: "닥스훈트 견종 키우는 견주들과 모여서 친목을 나누는 모임입니다. 견종을 키우면서 궁금한 점이나..."
      ),
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "2024.03.21 금요일 20:00",
        eventTitle: "훈련사님과 함께하는 멍BTI 진단하기 이번에 저랑 같이 함께해요!",
        eventDescription: "닥스훈트 견종 키우는 견주들과 모여서 친목을 나누는 모임입니다. 견종을 키우면서 궁금한 점이나..."
      ),
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "2024.03.21 금요일 20:00",
        eventTitle: "훈련사님과 함께하는 멍BTI 진단하기",
        eventDescription: "닥스훈트 견종 키우는 견주들과 모여서 친목을 나누는 모임입니다. 견종을 키우면서 궁금한 점이나..."
      ),
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "2024.03.21 금요일 20:00",
        eventTitle: "훈련사님과 함께하는 멍BTI 진단하기",
        eventDescription: "닥스훈트 견종 키우는 견주들과 모여서 친목을 나누는 모임입니다. 견종을 키우면서 궁금한 점이나..."
      ),
    ]
  }
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case onAppear
      case onTabIndexChange(Int)
      case onSortOptionChange(PND.SortOption)
      case onEventCardTap(EventCardView.ViewModel)
    }
    
    enum InternalAction: Equatable {
      
    }
    
    enum DelegateAction: Equatable {
      case pushToEventDetailView(eventId: String)
    }
    
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
   
    Reduce { state, action in
      switch action {
        
      case .view(.onAppear):
        return .none
        
      case .view(.onTabIndexChange(let index)):
        state.tabIndex = index
        return .none
        
      case .view(.onSortOptionChange(let sortOption)):
        state.sortOption = sortOption
        return .none
        
      case .view(.onEventCardTap(let viewModel)):
        return .send(.delegate(.pushToEventDetailView(eventId: viewModel.id)))
        
      default:
        return .none
      }
    }
  }
}

struct MainHomeView: View {
  
  @State var store: StoreOf<MainHomeFeature>
  
  var body: some View {
    VStack(alignment: .leading) {
      
      topNavigationBar
        .padding(.horizontal, 20)
      
      Spacer().frame(height: 8)
      
      SegmentControlView_SwiftUI(
        selectedIndex: $store.tabIndex,
        segmentTitles: ["이벤트 홈", "내 이벤트"]
      )
      .padding(.horizontal, 20)
      
      ScrollView(.vertical) {
        LazyVStack(alignment: .leading, spacing: 0) {
          Spacer().frame(height: 28)
          
          Text("원하시는 이벤트를 시작해보세요.🎈")
            .font(.system(size: 20, weight: .bold))
            .padding(.horizontal, 20)
          
          
          Spacer().frame(height: 50)
          
          Text("멍냥동")
            .font(.system(size: 20, weight: .bold))
            .background(alignment: .bottom) {
              Rectangle()
                .fill(PND.Colors.lightGreen.asColor)
                .frame(height: 10)
            }
            .padding(.horizontal, 20)
          
          Spacer().frame(height: 8)
          
          filterView
            .padding(.horizontal, 20)
          
          ForEach(store.eventCardVMs, id: \.id) { vm in
              EventCardView(viewModel: vm)
              .onTapGesture {
                store.send(.view(.onEventCardTap(vm)))
              }
          }
          
        }
      }
    }
    .onAppear() {
      store.send(.view(.onAppear))
    }
  }
  
  @ViewBuilder
  private var topNavigationBar: some View {
    HStack {
      
      Image(.pndMainIcon)
        .resizable()
        .frame(width: 19, height: 29)
        
      Spacer()
    }
  }
  
  @ViewBuilder
  private var filterView: some View {
    HStack {
      Text("현재 주목받고 있는 이벤트!")
        .font(.system(size: 16, weight: .semibold))
      
      Spacer()
      
      Menu {
        Button {
          store.send(.view(.onSortOptionChange(.newest)))
        } label: {
          HStack {
            Text(PND.SortOption.newest.description)
            Spacer()
            if store.sortOption == .newest {
              Image(systemName: "checkmark")
            }
          }
        }
        
        Button {
          store.send(.view(.onSortOptionChange(.deadline)))
        } label: {
          HStack {
            Text(PND.SortOption.deadline.description)
            Spacer()
            if store.sortOption == .deadline {
              Image(systemName: "checkmark")
            }
          }
        }

      } label: {
        Text(store.sortOption.description)
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(PND.Colors.commonBlack.asColor)
      }

      Spacer().frame(width: 4)
      
      Image(.iconArrDown)
        .resizable()
        .frame(width: 16, height: 16)
    }

  }
}

import Kingfisher

struct EventCardView: View {
  
  struct ViewModel: Equatable {
    let id: String
    let eventMainImageUrlString: String?
    let eventDateString: String
    let eventTitle: String
    let eventDescription: String
  }
  
  let viewModel: ViewModel
  
  var body: some View {
    HStack(alignment: .center) {
      
      KFImage.url(URL(string: viewModel.eventMainImageUrlString ?? ""))
        .placeholder { ProgressView () }
        .resizable()
        .frame(width: 90, height: 90)
        .scaledToFit()
        .cornerRadius(4)
      
      Spacer().frame(width: 8)
      
      VStack(alignment: .leading, spacing: 0) {
        
        Text(viewModel.eventDateString)
          .font(.system(size: 12, weight: .semibold))
          .foregroundStyle(PND.DS.primary)
          .lineLimit(1)
        
        
        Spacer().frame(height: 3)
        
        Text(viewModel.eventTitle)
          .font(.system(size: 14, weight: .semibold))
          .lineLimit(2)
          .multilineTextAlignment(.leading)
        
        Spacer().frame(height: 3)
        
        
        Text(viewModel.eventDescription)
          .font(.system(size: 12, weight: .regular))
          .lineLimit(2)
          .multilineTextAlignment(.leading)
        
        Spacer().frame(height: 4)
        
        HStack(spacing: 0) {
          KFImage.url(MockDataProvider.randomePetImageUrl)
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
            .clipShape(.circle)
          
          Spacer().frame(width: 5)
          
          Text("아롱맘")
            .font(.system(size: 12, weight: .medium))
          
          Spacer().frame(width: 5)
          
          Image(.iconGroup)
            .resizable()
            .frame(width: 16, height: 16)
          
          Spacer().frame(width: 2)
          
          Text("12명 참여중")
            .font(.system(size: 12, weight: .medium))
        }
      }
      
      
    }
    .padding(.horizontal, PND.Metrics.defaultSpacing)
    .padding(.vertical, 14)
    
  }
}

#Preview {
  MainHomeView(store: .init(initialState: .init(), reducer: { MainHomeFeature() }))
}

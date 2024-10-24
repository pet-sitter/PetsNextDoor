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
        eventDateString: "03.21 금요일 20:00",
        eventTitle: "훈련사님과 함께하는 멍BTI 진단하기",
        eventDescription: "닥스훈트 견종 키우는 견주들과 모여서 친목을 나누는 모임입니다. 견종을 키우면서 궁금한 점이나..."
      ),
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "03.21 금요일 20:00",
        eventTitle: "훈련사님과 함께하는 멍BTI 진단하기 이번에 저랑 같이 함께해요!",
        eventDescription: "닥스훈트 견종 키우는 견주들과 모여서 친목을 나누는 모임입니다. 견종을 키우면서 궁금한 점이나..."
      ),
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "03.21 금요일 20:00",
        eventTitle: "훈련사님과 함께하는 멍BTI 진단하기",
        eventDescription: "닥스훈트 견종 키우는 견주들과 모여서 친목을 나누는 모임입니다. 견종을 키우면서 궁금한 점이나..."
      ),
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "03.21 금요일 20:00",
        eventTitle: "훈련사님과 함께하는 멍BTI 진단하기",
        eventDescription: "닥스훈트 견종 키우는 견주들과 모여서 친목을 나누는 모임입니다. 견종을 키우면서 궁금한 점이나..."
      ),
    ]
    
    var myEventCardVMs: [MyEventCardView.ViewModel] = [
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "9월 1일(일) 오후 03:00~",
        eventTitle: "멍냥동 정기 봉사활동",
        eventLocation: "멍냥동 메인라운지",
        isToday: true
      ),
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "9월 1일(일) 오후 03:00~",
        eventTitle: "리트리버 모임",
        eventLocation: "멍냥동 메인라운지",
        isToday: false
      ),
      .init(
        id: UUID().uuidString,
        eventMainImageUrlString: MockDataProvider.randomPetImageUrlString,
        eventDateString: "9월 1일(일) 오후 03:00~",
        eventTitle: "닥스훈트 견주 소모임",
        eventLocation: "멍냥동 메인라운지",
        isToday: false
      ),
    
    ]
  }
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case onAppear
      case onTabIndexChange(Int)
      case onSortOptionChange(PND.SortOption)
      case onEventCardTap(EventCardView.ViewModel)
      case onSelectPlusButton
    }
    
    enum InternalAction: Equatable {
      
    }
    
    enum DelegateAction: Equatable {
      case pushToEventDetailView(eventId: String)
      case pushToCreateEventView
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
        
      case .view(.onSelectPlusButton):
        return .send(.delegate(.pushToCreateEventView))
        
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
      
      switch store.tabIndex {
      case 0:
        eventHomeView
        
      case 1:
        myEventView
        
      default:
        SwiftUI.EmptyView()
      }
      
    }
    .overlay(alignment: .bottomTrailing, content: {
      Button {
        store.send(.view(.onSelectPlusButton))
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
    })
    .onAppear() {
      store.send(.view(.onAppear))
    }
  }
  
  @ViewBuilder
  private var eventHomeView: some View {
    ScrollView(.vertical) {
      LazyVStack(alignment: .leading, spacing: 0) {

        Text("원하시는 이벤트를 시작해보세요.🎈")
          .font(.system(size: 20, weight: .bold))
          .padding(.horizontal, 20)
        
        
        Spacer().frame(height: 8)
        
        // 이벤트 만들기 배너
        HStack(spacing: 0) {
          
          VStack(alignment: .leading) {
            Text("이벤트 만들기")
              .font(.system(size: 16, weight: .bold))
            
            Text("함께하고 싶은 순간을 만들어보세요")
              .font(.system(size: 12, weight: .regular))
          }
          
          Spacer()
          
          Image(.createEventLogo)
          
        }
        .padding(.leading, 18)
        .padding(.trailing, 4)
        .background(Color(UIColor(hex: "#BFE4AC")))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .inset(by: 0.5)
            .stroke(PND.DS.primary, lineWidth: 1)
        )
        .padding(.horizontal, 20)
        
        Spacer().frame(height: 8)
        
        
        // 이벤트 찾기 배너
        HStack(spacing: 0) {
          
          VStack(alignment: .leading) {
            Text("이벤트 찾기")
              .font(.system(size: 16, weight: .bold))
              .foregroundStyle(PND.DS.commonWhite)
            
            Text("이웃들이 만든 이벤트를 찾아보세요")
              .font(.system(size: 12, weight: .regular))
              .foregroundStyle(PND.DS.commonWhite)
          }
          
          Spacer()
          
          Image(.findEventLogo)
          
        }
        .padding(.leading, 18)
        .padding(.trailing, 4)
        .background(PND.DS.primary)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(.horizontal, 20)
        
        
        
        Spacer().frame(height: 16)
        
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
  
  @ViewBuilder
  private var myEventView: some View {
    ScrollView(.vertical) {
      LazyVStack(spacing: 0) {
        
        Text("다가오는 이벤트 일정")
          .font(.system(size: 20, weight: .bold))
          .padding(.horizontal, 20)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer().frame(height: 12)
        
        ForEach(store.myEventCardVMs, id: \.id) { vm in
          MyEventCardView(viewModel: vm)
          Spacer().frame(height: 12)
        }
      }
//      .background(.red)
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
    HStack(alignment: .center, spacing: 0) {
      
      KFImage.url(URL(string: viewModel.eventMainImageUrlString ?? ""))
        .placeholder { ProgressView () }
        .resizable()
        .frame(width: 90, height: 90)
        .scaledToFit()
        .cornerRadius(4)
      
      Spacer().frame(width: 8)
      
      VStack(alignment: .leading, spacing: 0) {
        Text(viewModel.eventTitle)
          .font(.system(size: 14, weight: .semibold))
          .lineLimit(2)
          .multilineTextAlignment(.leading)
        
        Spacer().frame(height: 8)
        
        
        Text(viewModel.eventDescription)
          .font(.system(size: 12, weight: .regular))
          .lineLimit(2)
          .multilineTextAlignment(.leading)
        
        Spacer().frame(height: 8)
        
        HStack(spacing: 0) {

          Image(systemName: "clock")
            .resizable()
            .frame(width: 12, height: 12)
            .foregroundStyle(PND.DS.primary)
          
          Spacer().frame(width: 4)
          
          Text(viewModel.eventDateString)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(PND.DS.primary)
            .lineLimit(1)
          
          Spacer().frame(width: 8)
          
          Image(.iconGroup)
            .renderingMode(.template)
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundStyle(PND.DS.gray50)
          
          Spacer().frame(width: 2)
          
          Text("12명 참여중")
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(PND.DS.gray50)
        }
      }
      
      
    }
    .padding(.horizontal, PND.Metrics.defaultSpacing)
    .padding(.vertical, 14)
    
  }
}

struct MyEventCardView: View {
  
  struct ViewModel: Equatable {
    let id: String
    let eventMainImageUrlString: String?
    let eventDateString: String
    let eventTitle: String
    let eventLocation: String
    let isToday: Bool
  }
  
  let viewModel: ViewModel
  
  var body: some View {
    HStack(spacing: 0) {
      
//      Spacer().frame(width: 24)
      
      KFImage.url(URL(string: viewModel.eventMainImageUrlString ?? ""))
        .placeholder { ProgressView () }
        .resizable()
        .frame(width: 78, height: 78)
        .scaledToFit()
        .cornerRadius(4)
      
      Spacer().frame(width: 18)
      
      VStack(alignment: .leading, spacing: 0) {
        
        Text(viewModel.eventTitle)
          .font(.system(size: 14, weight: .semibold))
          .lineLimit(2)
          .multilineTextAlignment(.leading)
          .foregroundStyle(viewModel.isToday ? PND.DS.commonWhite : PND.DS.commonBlack)
        
        Spacer().frame(height: 8)
        
        HStack(spacing: 0) {
          
          Image(systemName: "clock")
            .resizable()
            .frame(width: 12, height: 12)
          
          Spacer().frame(width: 4)
          
          Text(viewModel.eventDateString)
            .font(.system(size: 12, weight: .semibold))
            .lineLimit(1)
        }
        .foregroundStyle(viewModel.isToday ? PND.DS.primary : PND.DS.gray50)
        
        Spacer().frame(height: 8)
        
        HStack(spacing: 0) {

          KFImage.url(MockDataProvider.randomePetImageUrl)
            .resizable()
            .frame(width: 16, height: 16)
            .clipShape(Circle())
          
          Spacer().frame(width: 4)
          
          Text("아롱맘")
            .font(.system(size: 12, weight: .semibold))
            .lineLimit(1)
          
          
          
          Spacer().frame(width: 12)
          
          Image(.iconGroup)
            .renderingMode(.template)
            .resizable()
            .frame(width: 16, height: 16)
          
          Spacer().frame(width: 2)
          
          Text("6/10")
            .font(.system(size: 12, weight: .medium))
          
          
          Spacer().frame(width: 12)
          
          Image(.iconPinLine)
            .renderingMode(.template)
            .resizable()
            .frame(width: 16, height: 16)
          
          Spacer().frame(width: 2)
          
          Text(viewModel.eventLocation)
            .font(.system(size: 12, weight: .medium))
            .lineLimit(1)
          
      
        }
        .foregroundStyle(viewModel.isToday ? PND.DS.commonWhite : PND.DS.commonBlack)
      }

      Spacer().frame(width: 24)
    }
//    .background(.green)
  
//
//    .padding(.horizontal, 12)
//    .padding(.vertical, 16)
//    .if(viewModel.isToday, { view in
//      view
//        .background(PND.DS.gray90)
//        .clipShape(RoundedRectangle(cornerRadius: 6))
//    })
    
//    .background(Color.red)
  }
}

#Preview {
  MainHomeView(store: .init(initialState: .init(), reducer: { MainHomeFeature() }))
}

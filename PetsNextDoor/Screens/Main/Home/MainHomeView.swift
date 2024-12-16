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
  
  @Dependency(\.userDataCenter) var userDataCenter
  @Dependency(\.eventService) var eventService
  
  struct Constants {
    static let pageSize: Int = 20
  }
  
  @ObservableState
  struct State: Equatable {
    var isLoading: Bool = false
    var tabIndex: Int = 0
    var sortOption: PND.SortOption = .newest // 최신순, 마감순
    
    var eventCardVMs: [EventCardView.ViewModel] = []
    
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
      case onEventCardTap(id: String)
      case onCreateNewEvent
      case onRefreshButtonTap
    }
    
    enum InternalAction: Equatable {
      case setIsLoading(Bool)
      case setEventCardVMs(with: PND.EventListResponseModel)
    }
    
    enum DelegateAction: Equatable {
      case pushToEventDetailView(eventId: String)
      case startEventCreationFlow
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
        return fetchInitialEvents()
        
      case .view(.onTabIndexChange(let index)):
        state.tabIndex = index
        return .none
        
      case .view(.onSortOptionChange(let sortOption)):
        state.sortOption = sortOption
        return .none
        
      case .view(.onEventCardTap(let id)):
        return .send(.delegate(.pushToEventDetailView(eventId: id)))
        
      case .view(.onCreateNewEvent):
        return .send(.delegate(.startEventCreationFlow))
        
      case .view(.onRefreshButtonTap):
        state.eventCardVMs.removeAll()
        return fetchInitialEvents()
        
        // Internal
        
      case .internal(.setIsLoading(let isLoading)):
        state.isLoading = isLoading
        return .none
        
      case .internal(.setEventCardVMs(let eventListResponseModel)):
        state.eventCardVMs = eventListResponseModel.items.map { event -> EventCardView.ViewModel in
          return EventCardView.ViewModel(
            id: event.id,
            eventMainImageUrlString: event.media.url,
            eventDateString: event.startAt,
            eventTitle: event.name,
            eventDescription: event.description
          )
        }
        return .none
        
      case .binding(\.tabIndex):
        return .none 
        
      default:
        return .none
      }
    }
  }
  
  private func fetchInitialEvents() -> Effect<Action> {
    return .run { send in
      await send(.internal(.setIsLoading(true)))
      
      let eventListResponseModel: PND.EventListResponseModel = try await eventService.getEvents(
        authorId: nil,
        page: 0,
        size: Constants.pageSize
      )
      
      await send(.internal(.setEventCardVMs(with: eventListResponseModel)))
      
      await send(.internal(.setIsLoading(false)))
    } catch: { error, send in
      print("❌ error: \(error)")
      await send(.internal(.setIsLoading(false)))
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
          
          VStack(alignment: .leading, spacing: 8) {
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
        .onTapGesture {
          store.send(.view(.onCreateNewEvent))
        }
        
        Spacer().frame(height: 8)
        
        
        // 이벤트 찾기 배너
        HStack(spacing: 0) {
          
          VStack(alignment: .leading, spacing: 8) {
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
        
        
        
        Spacer().frame(height: 24)
        
        // 동네 이름 + 리프레쉬 버튼
        
        HStack(spacing: 0) {
          Text("멍냥동")
            .font(.system(size: 20, weight: .bold))
            .background(alignment: .bottom) {
              Rectangle()
                .fill(PND.Colors.lightGreen.asColor)
                .frame(height: 10)
            }

          Spacer()
          
          Button {
            store.send(.view(.onRefreshButtonTap))
          } label: {
            Image(.refreshButton)
              .resizable()
              .frame(width: 18, height: 14)
              .padding(4)
              .background(PND.DS.lightGreen)
              .clipShape(Circle())
          }

          
        }
        .padding(.horizontal, 20)
        

        Spacer().frame(height: 8)
        
        Text("현재 주목받고 있는 이벤트!")
          .font(.system(size: 16, weight: .semibold))
          .padding(.horizontal, 20)
        
        
        ProgressView()
          .id(UUID())
          .isHidden(!store.isLoading)
          .frame(maxWidth: .infinity, alignment: .center)
        
        ForEach(store.eventCardVMs, id: \.id) { vm in
          EventCardView(viewModel: vm)
            .onTapGesture {
              store.send(.view(.onEventCardTap(id: vm.id)))
            }
        }
        
      }
    }
  }
  
  @ViewBuilder
  private var myEventView: some View {
    ScrollView(.vertical) {
      LazyVStack(spacing: 0) {
        
        Spacer().frame(height: 12)
        
        headerView
        
        Spacer().frame(height: 12)
        
        ForEach(store.myEventCardVMs, id: \.id) { vm in
          MyEventCardView(viewModel: vm)
            .onTapGesture {
              store.send(.view(.onEventCardTap(id: vm.id)))
            }
          Spacer().frame(height: 12)
        }
      }
    }

  }
  
  @ViewBuilder
  private var headerView: some View {
    HStack(spacing: 5) {
      Text("다가오는 이벤트 일정")
        .font(.system(size: 20, weight: .bold))

      
      Text("1")
        .font(.system(size: 20, weight: .bold))
        .foregroundStyle(PND.DS.primary)
        .lineLimit(1)
      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 20)
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
      
      Spacer().frame(width: 12)
      
      // 상세
      VStack(alignment: .leading, spacing: 0) {
        
        Text(viewModel.eventTitle)
          .font(.system(size: 16, weight: .semibold))
          .lineLimit(1)
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
    .contentShape(Rectangle())
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
          .foregroundStyle(PND.DS.commonBlack)
        
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

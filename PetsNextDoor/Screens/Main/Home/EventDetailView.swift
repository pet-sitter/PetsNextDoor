//
//  EventDetailView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 9/6/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct EventDetailFeature: Reducer {
  
  @Dependency(\.eventService) var eventService
  
  @ObservableState
  struct State: Equatable {
    let eventDetailId: String
    var isLoading: Bool = false
    
    var eventDetailModel: PND.Event?
    var isBottomButtonEnabled: Bool = false
    
    init(eventDetailId: String) {
      self.eventDetailId = eventDetailId
    }
  }
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case onAppear
      case onBackButtonTap
    }
    
    enum InternalAction: Equatable {
      case setIsLoading(Bool)
      case setEventDetailModel(PND.Event)
      case setIsBottomButtonEnabled(Bool)
    }
    
    enum DelegateAction: Equatable {
      case popView
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
        return .run { [state] send in
          
          await send(.internal(.setIsLoading(true)))
          
          let eventDetailModel = try await eventService.getEvent(id: state.eventDetailId)
       
          await send(.internal(.setEventDetailModel(eventDetailModel)))
          
          await send(.internal(.setIsLoading(false)))
          
          
        } catch: { error, send in
          await send(.internal(.setIsLoading(false)))
        }
        
      case .view(.onBackButtonTap):
        return .send(.delegate(.popView))
        
      case .internal(.setIsLoading(let isLoading)):
        state.isLoading = isLoading
        return .none
        
      case .internal(.setEventDetailModel(let model)):
        state.eventDetailModel = model
        return .none
        
      case .internal(.setIsBottomButtonEnabled(let isEnabled)):
        state.isBottomButtonEnabled = isEnabled
        return .none
        
      default:
        return .none
      }
    }
  }
}

import Kingfisher

struct EventDetailView: View {
  
  @State var store: StoreOf<EventDetailFeature>

  
  var body: some View {
    ZStack() {
      ScrollView(.vertical) {
        VStack(alignment: .leading) {
          
          KFImage.url(URL(string: store.eventDetailModel?.media.url ?? ""))
            .placeholder { ProgressView() }
            .resizable()
            .frame(width: UIScreen.fixedScreenSize.width, height: UIScreen.fixedScreenSize.height / 4)
          
          Spacer().frame(height: 20)
          
          // 이벤트 종류, 이벤트 태그, 참여 인원
          eventInfoTagView
          
          Spacer().frame(height: 12)
          
          // 이벤트명
          Text(store.eventDetailModel?.name ?? "")
            .lineLimit(2)
            .font(.system(size: 24, weight: .bold))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          Spacer().frame(height: 8)
          
          authorView
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          Spacer().frame(height: 8)
          
          Text(store.eventDetailModel?.description ?? "")
            .font(.system(size: 14, weight: .regular))
            .padding(.horizontal, PND.Metrics.defaultSpacing)
            .lineSpacing(5)
            
          Spacer().frame(height: 28)
          
          eventDateAndFeeView
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          eventLocationView
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          Spacer().frame(height: 8)
          
          if store.eventDetailModel?.type == .recurring {
            eventProgressView
          }

          Spacer()
        }
      
      }
      .redacted(reason: store.isLoading ? .placeholder : [])
     
      joinChatArea

    }
    .ignoresSafeArea(.all)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.view(.onBackButtonTap))
        } label: {
          Image(.iconUndo)
            .renderingMode(.template)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonWhite)
        }
      }
      
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          
        } label: {
          Image(.iconMenu)
            .renderingMode(.template)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonWhite)
        }
      }
    }
    .onAppear() {
      store.send(.view(.onAppear))
    }
  }
  
  @ViewBuilder
  private var eventInfoTagView: some View {
    Group {
      HStack(spacing: 0) {
        Text(store.eventDetailModel?.type.description ?? "")
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(PND.DS.gray20)
          .clipShape(Capsule())
        
        Spacer().frame(width: 4)
         
        
        Text(store.eventDetailModel?.topics.first ?? "")
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .background(PND.DS.gray20)
          .clipShape(Capsule())
        
        Spacer()
        
        HStack {
          Image(.iconGroup)
            .resizable()
            .frame(width: 16, height: 16)
          
          Text("?/\(store.eventDetailModel?.maxParticipants ?? 0)")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(PND.DS.gray20)
        .clipShape(Capsule())

      }
    }
    .font(.system(size: 14, weight: .medium))
    .padding(.horizontal, PND.Metrics.defaultSpacing)
  }
  
  
  @ViewBuilder
  private var authorView: some View {
    HStack(spacing: 0) {
      KFImage.url(URL(string: store.eventDetailModel?.author?.profileImageUrl ?? ""))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .scaledToFit()
        .frame(width: 16, height: 16)
        .clipShape(.circle)
      
      Spacer().frame(width: 5)
      
      Text(store.eventDetailModel?.author?.nickname ?? "")
        .font(.system(size: 12, weight: .medium))
    }
  }
  
  @ViewBuilder
  private var eventDateAndFeeView: some View {
    HStack(spacing: 12) {

      // 이벤트 날짜
      HStack(spacing: 0) {
        Spacer().frame(width: 12)
        VStack(alignment: .leading, spacing: 4) {
          Image(.iconCalendar)
            .renderingMode(.template)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonBlack)
          
          Text(DateConverter.extractDateAndTime(fromDateString: store.eventDetailModel?.createdAt ?? "")?.0 ?? "")
            .font(.system(size: 14, weight: .bold))
            .lineLimit(1)
          
          Text(DateConverter.extractDateAndTime(fromDateString: store.eventDetailModel?.createdAt ?? "")?.1 ?? "")
            .font(.system(size: 12, weight: .regular))
            .lineLimit(1)
        }
        .padding(.vertical, 12)
        
        Spacer(minLength: 12)
      }
      .background(
        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(Color(uiColor: .init(hex: "#EBEBEB")), lineWidth: 1)
      )

      // 이벤트 장소
      HStack(spacing: 0) {
        Spacer().frame(width: 12)
        VStack(alignment: .leading, spacing: 4) {
          Image(.iconPinLine)
            .renderingMode(.template)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonBlack)
          
          Text("참가 비용")
            .font(.system(size: 14, weight: .bold))
            .lineLimit(1)
          
          
          let feeString: String = if store.eventDetailModel?.fee == 0 {
            "무료"
          } else {
            "\(store.eventDetailModel?.fee ?? 0)".asCurrencyString + "원"
          }
          Text(feeString)
            .font(.system(size: 12, weight: .regular))
            .lineLimit(1)
        }
        .padding(.vertical, 12)
        Spacer(minLength: 12)
      }
      .background(
        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(Color(uiColor: .init(hex: "#EBEBEB")), lineWidth: 1)
      )
    }
  }
  
  
  @ViewBuilder
  private var eventLocationView: some View {
    HStack(spacing: 0) {
      Spacer().frame(width: 12)
      VStack(alignment: .leading, spacing: 4) {
        Image(.iconCalendar)
          .renderingMode(.template)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(PND.DS.commonBlack)
        
        Text("서울시 강서구 멍냥로 12")
          .font(.system(size: 14, weight: .bold))
          .lineLimit(1)
        
        Text("상가 1층 건물 앞에 모여서 만나요")
          .font(.system(size: 12, weight: .regular))
          .lineLimit(1)
      }
      .padding(.vertical, 12)
      
      Spacer(minLength: 12)
    }
    .background(
      RoundedRectangle(cornerRadius: 10)
        .strokeBorder(Color(uiColor: .init(hex: "#EBEBEB")), lineWidth: 1)
    )
  }
  
  
  // 이벤트 몇 회 진행됐는지
  @ViewBuilder
  private var eventProgressView: some View {
    HStack {
      Spacer()
      VStack(spacing: 2) {
        
        Group {
          Text("이벤트가 지금까지") +
          Text(" 3회 ")
            .foregroundStyle(PND.DS.primary)
          
          +
          Text("진행됐어요!")
        }
        .font(.system(size: 14, weight: .semibold))
        
        Text("최근 진행일 : 2024년 3월")
          .font(.system(size: 12, weight: .regular))
          .foregroundStyle(PND.DS.gray50)
      }
      Spacer()
    }
  }
  
  @ViewBuilder
  private var joinChatArea: some View {
    VStack {
      Spacer()
      
      BaseBottomButton_SwiftUI(
        title: "이벤트 채팅 참여하기",
        isEnabled: $store.isBottomButtonEnabled
      )

      Spacer().frame(height: 50)
    }
  }
}

#Preview {
  EventDetailView(store: .init(initialState: EventDetailFeature.State(eventDetailId: ""), reducer: { EventDetailFeature() }))
}

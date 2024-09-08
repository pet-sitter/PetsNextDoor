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
  
  @ObservableState
  struct State: Equatable {
    
  }
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case onBackButtonTap
    }
    
    enum InternalAction: Equatable {
      
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
        
      case .view(.onBackButtonTap):
        return .send(.delegate(.popView))
        
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
          KFImage.url(MockDataProvider.randomePetImageUrl)
            .placeholder { ProgressView() }
            .resizable()
            .frame(width: UIScreen.fixedScreenSize.width, height: UIScreen.fixedScreenSize.height / 4)
       
          
          Spacer().frame(height: 20)
          
          // 이벤트명
          Text("훈련사님과 함께하는 멍BTI 진단하기")
            .lineLimit(2)
            .font(.system(size: 24, weight: .bold))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          Spacer().frame(height: 8)
          
          eventInfoView
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          Spacer().frame(height: 16)
          
          Text("돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명 돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명돌봄모임에 대해서 상세한 설명 모임에 대해서 상세한 설명돌봄모임에 대해서")
            .font(.system(size: 14, weight: .regular))
            .padding(.horizontal, PND.Metrics.defaultSpacing)
            .lineSpacing(5)
            
          
          Spacer().frame(height: 28)
          
          eventDateAndLocationView
            .padding(.horizontal, PND.Metrics.defaultSpacing)
          
          Spacer()
        }
      
      }
     
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
    
  }
  
  
  @ViewBuilder
  private var eventInfoView: some View {
    HStack(spacing: 0) {
      KFImage.url(MockDataProvider.randomePetImageUrl)
        .resizable()
        .scaledToFit()
        .frame(width: 16, height: 16)
        .clipShape(.circle)
      
      Spacer().frame(width: 5)
      
      Text("아롱맘 • 염창1동")
        .font(.system(size: 12, weight: .medium))
      
      Spacer().frame(width: 5)
      
      Image(.iconPin)
        .resizable()
        .frame(width: 16, height: 16)
      
      Spacer().frame(width: 2)
      
      Text("서울 강서구")
        .font(.system(size: 12, weight: .medium))
      
      Spacer().frame(width: 7)
      
      Image(.iconGroup)
        .resizable()
        .frame(width: 16, height: 16)
      
      Spacer().frame(width: 5)
      
      Text("6/10")
        .font(.system(size: 12, weight: .medium))
    }
  }
  
  @ViewBuilder
  private var eventDateAndLocationView: some View {
    let availableSpace = UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2) - CGFloat(12)
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
          
          Text("2024.09.15")
            .font(.system(size: 14, weight: .bold))
            .lineLimit(1)
          
          Text("10:00 - 13:00")
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
//      .frame(width: availableSpace / 2)
      
      
      
      
      // 이벤트 장소
      HStack(spacing: 0) {
        Spacer().frame(width: 12)
        VStack(alignment: .leading, spacing: 4) {
          Image(.iconPinLine)
            .renderingMode(.template)
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(PND.DS.commonBlack)
          
          Text("서울시 강서구 멍냥로")
            .font(.system(size: 14, weight: .bold))
            .lineLimit(1)
          
          Text("12-5")
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
//      .frame(width: availableSpace / 2)
    }
  }
  
  @ViewBuilder
  private var joinChatArea: some View {
    VStack {
      Spacer()
      
      // 참여 인원
      
      HStack {
        HStack(spacing: -4) {
          ForEach(0..<3, id: \.self) { index in
            
            KFImage.url(MockDataProvider.randomePetImageUrl)
            .resizable()
            .scaledToFill()
            .frame(width: 20, height: 20)
            .clipShape(Circle())
            .background(
              Circle()
                .fill(PND.DS.commonWhite)
                .frame(width: 24, height: 24)
            )
          }
        }

        Text("5명 참여중")
          .lineLimit(1)
          .font(.system(size: CGFloat(12), weight: .medium))
          .foregroundStyle(PND.DS.commonBlack)
      }
      
      
      Spacer().frame(height: 17)
      
      Button {
        
      } label: {
        RoundedRectangle(cornerRadius: 4)
          .foregroundStyle(PND.Colors.primary.asColor)
          .overlay(
            Text("이벤트 채팅 참여하기")
              .font(.system(size: CGFloat(20), weight: .bold))
              .foregroundStyle(.white)
          )
          .frame(height: CGFloat(60))
          .padding(.horizontal, PND.Metrics.defaultSpacing)
        
      }
      .buttonStyle(ScaleEffectButtonStyle())
      
      Spacer().frame(height: 50)
    }
  }
}

//#Preview {
//  EventDetailView()
//}

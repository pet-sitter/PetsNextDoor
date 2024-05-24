//
//  ChatView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ChatFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    
  }
  
  enum Action: RestrictiveAction, BindableAction {

    enum ViewAction: Equatable {
      
    }
    
    enum InternalAction: Equatable {
      
    }
    
    enum DelegateAction: Equatable {
      
    }
    
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
    
    case binding(BindingAction<State>)
    
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      return .none 
    }
  }
}

struct ChatView: View {
  
  @State var store: StoreOf<ChatFeature>
  

  var body: some View {
    ScrollViewReader { proxy in
      

      SwiftUI.List {
        Group {
          
          textChatBubbleView
          textChatBubbleView
          textChatBubbleView
          textChatBubbleView
          
    
        }
        .background(.white)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        
      }
      .environment(\.defaultMinListRowHeight, 0)
      .listStyle(.plain)
    }
  }
  
  var textChatBubbleView: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer(minLength: 30)
        Text("채팅 테스트채팅 테스트채팅 테스트채팅 테스트채팅 테스트채팅 테스트채팅 테스트채팅 테스트채팅 테스트채팅 테스트채팅 테스트채팅 테스트채팅 테스트")
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
          .foregroundStyle(PND.DS.commonWhite)
          .padding(.horizontal, 16)
          .padding(.vertical, 10)
          .background(PND.DS.primary)
          .clipShape(
            .rect(
              topLeadingRadius: 20,
              bottomLeadingRadius: 20,
              bottomTrailingRadius: 20,
              topTrailingRadius: 0
            )
          )
        DefaultSpacer(axis: .horizontal)
      }
      Spacer().frame(height: 4)
    }
  }
  
  
  
//  private var topNavigationBarView: some View {
//    HStack {
//      Spacer().frame(width: PND.Metrics.defaultSpacing)
//
//      
//      Text("채팅")
//        .foregroundStyle(PND.Colors.commonBlack.asColor)
//        .font(.system(size: 20, weight: .bold))
//    
//      Spacer()
//      
//      Button(action: {
//  
//      }, label: {
//        Image(R.image.icon_setting)
//          .resizable()
//          .frame(width: 24, height: 24)
//          .tint(PND.Colors.commonBlack.asColor)
//      })
//      
//      Spacer().frame(width: PND.Metrics.defaultSpacing)
//    }
//  }
}

#Preview {
  ChatView(store: .init(initialState: .init(), reducer: { ChatFeature()}))
}

//
//  ChatMembersView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 8/25/24.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

@Reducer
struct ChatMembersFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    let users: [PND.UserInfoModel]
    
    var isUserProfileViewPresented: Bool = false
    var selectedUserProfile: PND.UserInfoModel? = nil
  }
  
  enum Action: BindableAction, Equatable {
    
    case onUserProfileTap(PND.UserInfoModel)
    case onUserProfileViewDismiss
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        
      case .onUserProfileTap(let user):
        state.isUserProfileViewPresented = true
        state.selectedUserProfile = user
        return .none
        
      case .onUserProfileViewDismiss:
        state.isUserProfileViewPresented = false
        state.selectedUserProfile = nil
        return .none
        
      case .binding:
        return .none
      }
    }
  }
}

struct ChatMembersView: View {
  
  @State var store: StoreOf<ChatMembersFeature>
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    ScrollView(.vertical) {
      DefaultSpacer(axis: .vertical)
      VStack(spacing: CGFloat(9)) {
        ForEach(store.users, id: \.id) { user in
          userRowView(user)
            .onTapGesture {
              store.send(.onUserProfileTap(user))
            }
        }
      }
    }
    .fullScreenCover(
      isPresented: $store.isUserProfileViewPresented,
      onDismiss: {
        store.send(.onUserProfileViewDismiss)
      },
      content: {
        if let selectedUser = store.selectedUserProfile {
          ChatUserProfileView(user: selectedUser)
        } else {
          Text("Invalid User")
        }

      }
    )
  }
  
  @ViewBuilder
  private func userRowView(_ user: PND.UserInfoModel) -> some View {
    HStack(spacing: 0) {
      KFImage.url(URL(string: user.profileImageUrl ?? ""))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .frame(width: 48, height: 48)
        .clipShape(Circle())
      
      Spacer().frame(width: CGFloat(17))
      
      Text("\(user.nickname)")
        .foregroundStyle(PND.DS.commonBlack)
        .font(.system(size: 16, weight: .medium))
      
      if true {
        Spacer().frame(width: 5)
        
        Image(.crown)
          .resizable()
          .frame(width: 30, height: 30)
      }
      
      Spacer()
      
      Image(systemName: "chevron.right")
        .foregroundStyle(PND.DS.commonBlack)
    }
    .padding(.horizontal, PND.Metrics.defaultSpacing)
    .contentShape(Rectangle())
  }
}


struct ChatUserProfileView: View {
  
  @State var user: PND.UserInfoModel
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack(spacing: 0) {
      
      KFImage.url(URL(string: "https://placedog.net/400/400random"))
        .resizable()
        .placeholder {
          ProgressView()
        }
        .frame(width: .screenWidth, height: .screenHeight / CGFloat(2))
      
      Color.white
        .frame(width: .screenWidth, height: .screenHeight / CGFloat(2))
    }
    .onDragDownGesture {
      dismiss()
    }
    .overlay(alignment: .center, content: {
      VStack(spacing: 0) {
        KFImage.url(MockDataProvider.randomePetImageUrl)
          .resizable()
          .placeholder {
            ProgressView()
          }
          .frame(width: 120, height: 120)
          .clipShape(Circle())
        
        Spacer().frame(height: 15)
        
        Text(user.nickname)
          .foregroundStyle(PND.DS.commonBlack)
          .font(.system(size: 20, weight: .bold))
        
        Spacer().frame(height: 50)
        
        // 내보내기 / 신고하기
        HStack(spacing: 48) {
          Button {
            
          } label: {
            VStack(spacing: 6) {
              ZStack {
                Circle()
                  .fill(PND.DS.gray20)
                  .frame(width: 48, height: 48)
                
                Image(systemName: "xmark.circle")
                  .frame(width: 38, height: 38)
                  .foregroundStyle(PND.DS.commonBlack)
                
              }
              
              Text("내보내기")
                .foregroundStyle(PND.DS.commonBlack)
                .font(.system(size: 16, weight: .medium))
            }
          }
          
          Button {
            
          } label: {
            VStack(spacing: 6) {
              ZStack {
                Circle()
                  .fill(PND.DS.gray20)
                  .frame(width: 48, height: 48)
                
                Image(systemName: "light.beacon.max")
                  .frame(width: 38, height: 38)
                  .foregroundStyle(PND.DS.commonBlack)
                
              }
              
              Text("신고하기")
                .foregroundStyle(PND.DS.commonBlack)
                .font(.system(size: 16, weight: .medium))
            }
          }
        }
        
      }
    })
    .ignoresSafeArea(.all)
  }
}

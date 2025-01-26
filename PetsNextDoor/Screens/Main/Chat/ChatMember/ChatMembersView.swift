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
  
    var roomName: String = ""
    var users: [PND.UserInfoModel]
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
    HStack(spacing: 0) {
      Color.clear
        .frame(width: UIScreen.fixedScreenSize.width * 0.2)
      
      VStack(spacing: 0) {
        
        Spacer().frame(height: 75)
        
        // 이벤트 이름
        HStack {
          VStack(alignment: .leading) {
            Text(store.roomName)
              .font(.system(size: 20, weight: .bold))
            
            Spacer().frame(height: 5)
            
            Text("날짜 장소")
              .font(.system(size: 12, weight: .regular))
          }
          Spacer()
          
          Image(systemName: "chevron.right")
        }
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        Spacer().frame(height: PND.Metrics.defaultSpacing)
        
        Divider()
        
        Spacer().frame(height: 13)
        
        // 공지사항
        HStack {
          Text("공지사항")
            .font(.system(size: 20, weight: .bold))
          Spacer()
          Image(systemName: "chevron.right")
        }
        .padding(.horizontal, PND.Metrics.defaultSpacing)

        Spacer().frame(height: 13)
        
        Divider()
        
        Spacer().frame(height: 13)
        
        // 멤버 목록
        HStack {
          Text("멤버 목록")
            .font(.system(size: 16, weight: .medium))
          Spacer()
        }
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        
        Spacer().frame(height: 15)
        
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
      }
      .frame(width: UIScreen.fixedScreenSize.width * 0.8)
      .background(Color.white)
      
      
    }
    .ignoresSafeArea()
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
    ZStack {
      KFImage.url(URL(string: "https://placedog.net/400/400random"))
        .resizable()
        .placeholder {
          ProgressView()
        }
        .blur(radius: 10)
      
      
      VStack(spacing: 0) {
        KFImage.url(MockDataProvider.randomePetImageUrl)
          .resizable()
          .placeholder {
            ProgressView()
          }
          .aspectRatio(contentMode: .fit)
          .frame(width: 120, height: 120)
          .clipShape(Circle())
        
        Spacer().frame(height: 17)
        
        Text(user.nickname)
          .foregroundStyle(PND.DS.commonWhite)
          .font(.system(size: 20, weight: .bold))
        
        Spacer().frame(height: 15)
        
        Text("내보내기")
          .font(.system(size: 14, weight: .bold))
          .foregroundStyle(PND.DS.commonWhite)
          .padding(.horizontal, 16)
          .padding(.vertical, 8)
          .background(Color(hex: "#FF2727"))
          .clipShape(Capsule())

      }
    }
    .onDragDownGesture {
      dismiss()
    }
    .overlay(alignment: .bottom , content: {
      VStack(spacing: 1) {
        Text("신고하기")
          .foregroundStyle(PND.DS.commonWhite)
        Rectangle()
          .fill(PND.DS.commonWhite)
          .frame(width: 55, height: 1)
      }
      .offset(y: -70)
    })
    .ignoresSafeArea(.all)
  }
}

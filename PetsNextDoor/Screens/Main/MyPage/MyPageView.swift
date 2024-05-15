//
//  MyPageView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/22.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MyPageFeature: Reducer {
  
  @Dependency(\.userService) private var userService

  @ObservableState
  struct State: Equatable {
    
    var myProfileImageUrlString: String? = nil

    var myPetInfoState: MyPetInfoFeature.State    = .init()
    var myActivityState: MyActivityFeature.State  = .init()
  }
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case onAppear
    }
    
    enum InternalAction: Equatable {
      case setMyProfileImageUrlString(String)
    }
    
    enum DelegateAction: Equatable {
      
    }
    
    case view(ViewAction)
    case `internal`(InternalAction)
    case delegate(DelegateAction)
    case binding(BindingAction<State>)
    
    // Child Actions
    case myPetInfoAction(MyPetInfoFeature.Action)
    case myActivityAction(MyActivityFeature.Action)
  }
  
  var body: some Reducer<State, Action> {
    
    Scope(state: \.myPetInfoState, action: \.myPetInfoAction)   { MyPetInfoFeature() }
    Scope(state: \.myActivityState, action: \.myActivityAction) { MyActivityFeature() }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .view(.onAppear):
        return .run { send in
          
          let myProfileInfo = try await userService.getMyProfileInfo()
          
          if let profileImageUrl = myProfileInfo.profileImageUrl {
            await send(.internal(.setMyProfileImageUrlString(profileImageUrl)))
          }
          

        } catch: { error, send in
          
        }
        
      case .internal(.setMyProfileImageUrlString(let urlString)):
        state.myProfileImageUrlString = urlString
        return .none
        
      case .delegate:
        return .none
        
      case .binding:
        return .none
        
        
        // Child Actions
        
      case .myPetInfoAction:
        return .none
        
      case .myActivityAction:
        return .none
      }
    }
  }
}


struct MyPageView: View {
  
  @State var store: StoreOf<MyPageFeature>
  
  @State private var selectedTab: Tab = .mySchedule
  @Namespace private var tabNamespace
  
  enum Tab: CaseIterable, Equatable {
    case mySchedule
    case myActivity
    case myPetInfo
    
    var description: String {
      switch self {
      case .mySchedule: "나의 일정"
      case .myActivity: "나의 활동"
      case .myPetInfo:  "반려동물 정보"
      }
    }
  }

  
  var body: some View {
    VStack {
      topNavigationBarView
      
      DefaultSpacer(axis: .vertical)
      
      profileInfoHeaderView
      
      DefaultSpacer(axis: .vertical)
      Rectangle()
        .foregroundStyle(PND.DS.gray20)
        .frame(height: 1)
        .padding(.horizontal, PND.Metrics.defaultSpacing)
      
      segmentTabView
      
      ScrollView(.vertical) {
        
        switch selectedTab {
          
        case .mySchedule:
          Text("N/A mySchedule")
          
        case .myActivity:
          MyActivityView(store: store.scope(state: \.myActivityState, action: \.myActivityAction))
          
        case .myPetInfo:
          MyPetInfoView(store: store.scope(state: \.myPetInfoState, action: \.myPetInfoAction))
        }
      }
      .animation(nil, value: selectedTab)
    }

    .onAppear {
      store.send(.view(.onAppear))
    }
  }
  
  var profileInfoHeaderView: some View {
    HStack(spacing: 0) {
      DefaultSpacer(axis: .horizontal)
      
      // 정보
      VStack(alignment: .leading, spacing: 5) {
        
        Text("아롱맘님")
          .font(.system(size: 20, weight: .bold))

        
        HStack(spacing: 28) {
          // 돌봄메이트
          VStack(alignment: .leading, spacing: 5) {
            Text("12")
              .font(.system(size: 20, weight: .bold))
            Text("돌봄메이트")
              .font(.system(size: 14))
          }
          
          // 돌봄횟수
          VStack(alignment: .leading, spacing: 5) {
            Text("3")
              .font(.system(size: 20, weight: .bold))
            Text("돌봄횟수")
              .font(.system(size: 14))
          }
          
          // 받은 후기
          VStack(alignment: .leading, spacing: 5) {
            Text("24")
              .font(.system(size: 20, weight: .bold))
            Text("받은 후기")
              .font(.system(size: 14))
          }
        }
      }
      
      Spacer()
      
      // 프로필 사진
      CircularProfileImageView(imageUrlString: MockDataProvider.randomPetImageUrlString)
        .frame(width: 60, height: 60)
      
      DefaultSpacer(axis: .horizontal)
    }
  }
  
  private var segmentTabView: some View {
    HStack {
      ForEach(Tab.allCases, id: \.self) { currentTab in
        ZStack(alignment: .bottom) {
          Text(currentTab.description)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(selectedTab == currentTab ? PND.DS.commonBlack : PND.DS.gray50)
          
          if selectedTab == currentTab {
            RoundedRectangle(cornerRadius: 10)
              .fill(PND.DS.commonBlack)
              .matchedGeometryEffect(id: "tabNamespaceId", in: tabNamespace)
              .frame(height: 2)
              .frame(width: UIScreen.fixedScreenSize.width / 3 - (PND.Metrics.defaultSpacing * 2))
              .offset(y: 10)
          }

        }
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .onTapGesture {
          withAnimation(.spring(.snappy(duration: 0.25))) {
            selectedTab = currentTab
          }
        }
      }
    }
  }
  
  private var topNavigationBarView: some View {
    HStack {
      Spacer().frame(width: PND.Metrics.defaultSpacing)

      
      Text("마이페이지")
        .foregroundStyle(PND.Colors.commonBlack.asColor)
        .font(.system(size: 20, weight: .bold))
    
      Spacer()
      
      Button(action: {
  
      }, label: {
        Image(R.image.icon_setting)
          .resizable()
          .frame(width: 24, height: 24)
          .tint(PND.Colors.commonBlack.asColor)
      })
      
      Spacer().frame(width: PND.Metrics.defaultSpacing)
    }
  }
  

  
}

#Preview {
  MyPageView(store: .init(initialState: .init(), reducer: { MyPageFeature() }))
}

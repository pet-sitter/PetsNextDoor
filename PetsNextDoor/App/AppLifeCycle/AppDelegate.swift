//
//  AppDelegate.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/06/17.
//
import SwiftUI
import ComposableArchitecture
import FirebaseCore
import GoogleSignIn
import IQKeyboardManagerSwift

@Reducer
struct PNDRootFeature: Reducer {
  
  @ObservableState
  enum State: Equatable {
    case splash
    case login(state: LoginFeature.State = .init())
    case mainTab(state: MainTabBarFeature.State = .init())
    
    init() { self = .splash }
  }
  
  enum Action {
    case onAppear
    
    case loginAction(LoginFeature.Action)
    case mainTabBarAction(MainTabBarFeature.Action)
  }
  
  @Dependency(\.userDefaultsManager) var userDefaultsManager
  
  var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
//        state = .login(state: LoginFeature.State())
        state = .mainTab(state: MainTabBarFeature.State())
//        if let isLoggedIn = userDefaultsManager.get(.isLoggedIn) as? Bool, isLoggedIn == true {
//          state = .mainTab(state: MainTabBarFeature.State())
//        } else {
//          state = .login(state: LoginFeature.State())
//        }
        return .none
        
      case .loginAction(.delegate(.moveToMainTabBarView)):
        state = .mainTab(state: MainTabBarFeature.State())
        return .none 
        
      default:
        return .none
      }
    }
    .ifCaseLet(\.login, action: \.loginAction)        { LoginFeature() }
    .ifCaseLet(\.mainTab, action: \.mainTabBarAction) { MainTabBarFeature() }
  }
}

@main
struct PNDRootApp: App {
  
  private let store = Store(initialState: PNDRootFeature.State()) { PNDRootFeature() }
  
  init() {
    FirebaseApp.configure()
    IQKeyboardManager.shared.enable = true
  }
  
  var body: some Scene {
    WindowGroup {
      RootView(store: store)
        .enableGlobalLoading()
        .onOpenURL { url in
        }
    }
  }
}
 


@Reducer
struct MainTabBarFeature: Reducer {
  
  @Dependency(\.userDataCenter) var userDataCenter
  
  @ObservableState
  struct State: Equatable {
    
    var selectedTab: MainTabBarView.MainTab = .home
    
    var homeState: HomeFeature.State            = .init()
    var communityState: CommunityFeature.State  = .init()
    var chatListState: ChatListFeature.State    = .init()
    var calendarState: CalendarFeature.State    = .init()
    var myPageState: MyPageFeature.State        = .init()
    
    var path: StackState<MainTabNavigationPath.State> = .init()
  }
  
  enum Action: BindableAction {
    
    case onAppear
    
    case binding(BindingAction<State>)
    
    case homeAction(HomeFeature.Action)
    case communityAction(CommunityFeature.Action)
    case chatListAction(ChatListFeature.Action)
    case calendarAction(CalendarFeature.Action)
    case myPageAction(MyPageFeature.Action)
    
    case path(StackAction<MainTabNavigationPath.State, MainTabNavigationPath.Action>)
  }
  
  var body: some Reducer<State,Action> {
    Scope(state: \.homeState, action: \.homeAction)           {   HomeFeature()      }
    Scope(state: \.communityState, action: \.communityAction) {   CommunityFeature() }
    Scope(state: \.chatListState, action: \.chatListAction)   {   ChatListFeature()  }
    Scope(state: \.calendarState, action: \.calendarAction)   {   CalendarFeature()  }
    Scope(state: \.myPageState, action: \.myPageAction)       {   MyPageFeature()    }
    
    BindingReducer()
    navigationReducer
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .path:
        return .none
        
      default:
        return .none
      }
    }
  }
  
  var navigationReducer: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
				return .run { _ in
					await userDataCenter.configureInitialUserData()
				}
        
        // 홈화면 액션
      case .homeAction(.delegate(.pushToSelectPetListView)):
        state.path.append(.selectPetList(SelectPetListFeature.State()))
        return .none 
        
      case .homeAction(.delegate(.pushToUrgentPostDetailView(let postId))):
        state.path.append(.urgentPostDetail(UrgentPostDetailFeature.State(postId: postId)))
        return .none
        
      case .homeAction(.delegate(.selectMyPageView)):
        state.selectedTab = .myPage
        return .none
        
        // 채팅방 목록 액션
        
      case .chatListAction(.onChatRoomTap):
        state.path.append(.chat(ChatFeature.State()))
        return .none
        
        // 마이페이지 화면 액션
				
			case .myPageAction(.myActivityAction(.onUrgentPostTap(let postId))):
				state.path.append(.urgentPostDetail(UrgentPostDetailFeature.State(postId: postId)))
				return .none
        
				
				// 그 외
      case let .path(action):
        switch action {
        case .element(id: _, action: .selectPetList(.pushToSelectCareConditionsView(let urgentModel))):
          state.path.append(.selectCareConditions(SelectCareConditionFeature.State(urgentPostModel: urgentModel)))
          return .none
          
        case .element(id: _, action: .selectPetList(.popToHomeView)):
          let _ = state.path.popLast()
          return .none 
          
        case .element(id: _, action: .selectCareConditions(.pushToSelectOtherRequirementsView(let urgentModel))):
          state.path.append(.selectOtherRequirements(SelectOtherRequirementsFeature.State(urgentPostModel: urgentModel)))
          return .none
          
        case .element(id: _, action: .selectOtherRequirements(.pushToWriteUrgentPostView(let urgentModel))):
          state.path.append(.writeUrgentPost(WriteUrgentPostFeature.State(urgentPostModel: urgentModel)))
          return .none
          
        case .element(id: _, action: .writeUrgentPost(.onPostUploadComplete(let postId))):
          let _ = state.path.popLast()
          let _ = state.path.popLast()
          let _ = state.path.popLast()
          let _ = state.path.popLast()
          state.path.append(.urgentPostDetail(UrgentPostDetailFeature.State(postId: postId)))
          return .none
				
          
        default:
          return .none
        }
        

      default:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      MainTabNavigationPath()
    }
  }
}


struct MainTabBarView: View {
  
  @State var store: StoreOf<MainTabBarFeature>
  
  private let imageSize: CGFloat = 32
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      contentView
    } destination: { store in
      
      switch store.state  {
      case .urgentPostDetail:
        if let store = store.scope(state: \.urgentPostDetail, action: \.urgentPostDetail) {
          UrgentPostDetailView(store: store)
        }
        
      case .selectPetList:
        if let store = store.scope(state: \.selectPetList, action: \.selectPetList) {
          SelectPetListView(store: store)
        }
        
      case .selectCareConditions:
        if let store = store.scope(state: \.selectCareConditions, action: \.selectCareConditions) {
          SelectCareConditionsView(store: store)
        }
        
      case .selectOtherRequirements:
        if let store = store.scope(state: \.selectOtherRequirements, action: \.selectOtherRequirements) {
          SelectOtherRequirementsView(store: store)
        }
        
      case .chat:
        if let store = store.scope(state: \.chat, action: \.chat) {
          ChatView(store: store)
        }
        
      case .writeUrgentPost:
        if let store = store.scope(state: \.writeUrgentPost, action: \.writeUrgentPost) {
          WriteUrgentPostView(store: store)
        }
				
			case .myActivity(_):
				if let store = store.scope(state: \.myActivity, action: \.myActivity) {
					MyActivityView(store: store)
				}
				

				
			@unknown default:
        Text("UNDEFINED VIEW")
      }
    }
    .tint(PND.DS.commonBlack)
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  private var contentView: some View {
    TabView(selection: $store.selectedTab) {
      HomeView(store: store.scope(state: \.homeState, action: \.homeAction))
        .tabItem {
          MainTab
            .home
            .image(isSelected: store.selectedTab == .home)
            .frame(width: imageSize, height: imageSize)
        }
        .tag(MainTab.home)
  
      
      CommunityView(store: store.scope(state: \.communityState, action: \.communityAction))
        .tabItem {
          MainTab
            .community
            .image(isSelected: store.selectedTab == .community)
            .frame(width: imageSize, height: imageSize)
        }
        .tag(MainTab.community)
      
      ChatListView(store: store.scope(state: \.chatListState, action: \.chatListAction))
        .tabItem {
          MainTab
            .chatList
            .image(isSelected: store.selectedTab == .chatList)
            .frame(width: imageSize, height: imageSize)
        }
        .tag(MainTab.chatList)
      
      CalendarView(store: store.scope(state: \.calendarState, action: \.calendarAction))
        .tabItem {
          MainTab
            .calendar
            .image(isSelected: store.selectedTab == .calendar)
            .frame(width: imageSize, height: imageSize)
        }
        .tag(MainTab.calendar)
      
      MyPageView(store: store.scope(state: \.myPageState, action: \.myPageAction))
        .tabItem {
          MainTab
            .myPage
            .image(isSelected: store.selectedTab == .myPage)
            .frame(width: imageSize, height: imageSize)
        }
        .tag(MainTab.myPage)
    }
  }
  
  enum MainTab: CaseIterable {
    
    case home
    case community
    case chatList
    case calendar
    case myPage
    
    func image(isSelected: Bool) -> Image {
      switch self {
      case .home:
        Image(isSelected ? .iconHomeSelected : .iconHome)
          .resizable()
        
      case .community:
        Image(isSelected ? .iconCommunitySelected : .iconCommunity)
          .resizable()
        
      case .chatList:
        Image(isSelected ? .iconChatSelected : .iconChat)
          .resizable()
        
      case .calendar:
        Image(isSelected ? .iconCalendarSelected : .iconCalendar)
          .resizable()
        
      case .myPage:
        Image(isSelected ? .iconUserSelected : .iconUser)
          .resizable()
      }
    }
  }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return true
  }

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {

  }
}

extension AppDelegate {
  
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}

extension UINavigationController {
  
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }
}

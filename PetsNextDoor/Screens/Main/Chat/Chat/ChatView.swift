//
//  ChatView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/24.
//

import Combine
import ComposableArchitecture
import SwiftUI
import PhotosUI


enum ChatViewType: Equatable, Identifiable {
  
  case text(ChatTextBubbleViewModel, topSpace: CGFloat? = nil, bottomSpace: CGFloat? = nil)
  case singleImage(SingleChatImageViewModel, topSpace: CGFloat? = nil, bottomSpace: CGFloat? = nil)
  case multipleImages(MultipleChatImageViewModel, topSpace: CGFloat? = nil, bottomSpace: CGFloat? = nil)
  
  var id: String {
    switch self {
    case .text(let vm, _, _):
      return vm.id
      
    case .singleImage(let vm, _, _):
      return vm.id
      
    case .multipleImages(let vm, _, _):
      return vm.id
      
    }
  }
}




@Reducer
struct ChatFeature: Reducer {
  
  @Dependency(\.chatDataProvider) var chatDataProvider
  
  @ObservableState
  struct State: Equatable {
    
    var chats: [ChatViewType] = []
    var roomName: String = ""
    var textFieldText: String = ""
    var isUploadingImage: Bool = false
    var selectedPhotoPickerItems: [PhotosPickerItem] = []
    var connectivityState = ConnectivityState.disconnected
    var isMemberListViewPresented: Bool = false
    
    // Sub States
    
    var chatMemberListState: ChatMembersFeature.State
    
    enum ConnectivityState: String {
      case connecting
      case connected
      case disconnected
    }
    
    init() { // 임시
      
      self.chatMemberListState = ChatMembersFeature.State(users: [
        // 임시 코드
        .init(id: "0", nickname: "호두 언니", profileImageUrl: "https://placedog.net/200/200random", pets: []),
        .init(id: "1", nickname: "레오", profileImageUrl: "https://placedog.net/200/200random", pets: []),
        .init(id: "2", nickname: "크리스티아누 호달두", profileImageUrl: "https://placedog.net/200/200random", pets: []),
        .init(id: "3", nickname: "리오넬 메시", profileImageUrl: "https://placedog.net/200/200random", pets: [])
      ])
    }
  }
  
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      case onAppear
      case onBackButtonTap
      case onMoreButtonTap
      case onMemberListViewBlankAreaTap
      case onFirstChatOffsetChange(CGFloat)
      
      // ChatTextField
      case onSendChatButtonTap
      case onUserImageSelection
    }
    
    enum InternalAction: Equatable {
      case setInitialRoomInfo(PND.ChatRoomModel)
      case chatDataProviderAction(ChatDataProvider.Action)
      case setIsUploadingImage(Bool)
      case setSelectedPhotoPickerItems([PhotosPickerItem])
    }
    
    enum DelegateAction: Equatable {
      
    }
    
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
    
    case binding(BindingAction<State>)
    
    // Sub Actions
    case chatMemberListAction(ChatMembersFeature.Action)
  }
  
  enum CancellableID {
    
  }
  
  init() {
    
  }
  
  var body: some Reducer<State, Action> {
    
    BindingReducer()
    
    Scope(
      state: \.chatMemberListState,
      action: /Action.chatMemberListAction
    ) {
      ChatMembersFeature()
    }
    
    Reduce { state, action in
      
      switch action {
        
        // View
      case .view(.onAppear):
        return .run { send in
          try await loadOldChats(send)
          try await observeChatActionStream(send)
          
          let roomInfo = try await chatDataProvider.fetchRoomInfo()
          await send(Action.internal(.setInitialRoomInfo(roomInfo)))
        } catch: { error, send in
          print("❌ error: \(error)")
        }
        
      case .view(.onBackButtonTap):
        ()
        
      case .view(.onMoreButtonTap):
        state.isMemberListViewPresented = true
        
        
      case .view(.onMemberListViewBlankAreaTap):
        state.isMemberListViewPresented = false
        
        // Internal
        
      case .view(.onFirstChatOffsetChange(let offset)):
        return checkIfFirstChatOverThreshold(offset)
        
      case .internal(.setInitialRoomInfo(let chatRoomModel)):
        state.roomName = chatRoomModel.roomName
        state.chatMemberListState.roomName = chatRoomModel.roomName
        
      case .internal(.chatDataProviderAction(.onConnect)):
        ()
        
      case .internal(.chatDataProviderAction(.onDisconnect)):
        ()
        
      case .internal(.chatDataProviderAction(.onReceiveNewChatType(let chatViewTypes))):
        state.chats = chatViewTypes

      case .internal(.setIsUploadingImage(let isLoading)):
        state.isUploadingImage = isLoading
        
      case .internal(.setSelectedPhotoPickerItems(let pickerItems)):
        state.selectedPhotoPickerItems = pickerItems

        
      case .view(.onSendChatButtonTap):
        // empty, 숫자 초과 등 검사 로직 추가
        guard state.textFieldText.isEmpty == false else { return .none }
        
        let messageToSend = state.textFieldText
        state.textFieldText = ""
        return Effect.run { _ in
          await chatDataProvider.sendChat(text: messageToSend)
        }
        
      case .view(.onUserImageSelection):
        guard state.selectedPhotoPickerItems.isEmpty == false else { return .none }
        
        return .run { [state] send in
          await send(.internal(.setIsUploadingImage(true)))
          
          try await chatDataProvider.sendImages(withPhotosPickerItems: state.selectedPhotoPickerItems)
          
          await send(.internal(.setSelectedPhotoPickerItems([])))
          await send(.internal(.setIsUploadingImage(false)))
          
        } catch: { error, send in
          
          await send(.internal(.setIsUploadingImage(false)))
          
          Toast
            .shared
            .present(
              title: "이미지 업로드에 실패했어요. 잠시 후 다시 시도해주세요.",
              symbolType: .xMark
            )
          
          print("❌ Error uploading images in ChatFeature : \(error)")
        }
        
        // Delegate
      case .delegate:
        break
        
        // Bindings
      case .binding:
        break
        
      default:
        break
      }
      
      return Effect.none
    }
    
    chatMemberListReducer
  }
  
  var chatMemberListReducer: some Reducer<State, Action> {
    Reduce { state, action in
      guard case .chatMemberListAction(let memberListAction) = action else { return Effect.none }
      
      switch memberListAction {
        
      default:
        break
      }
    
      return Effect.none
    }
  }
  
  private func observeChatActionStream(_ send: Send<ChatFeature.Action>) async throws {
    let actions = chatDataProvider.observeChatActionStream()
    
    for await action in actions {
      await send(.internal(.chatDataProviderAction(action)))
    }
  }
  
  private func loadOldChats(_ send: Send<ChatFeature.Action>) async throws {
    let chats = try await chatDataProvider.fetchOldChats()
    await send(.internal(.chatDataProviderAction(.onReceiveNewChatType(chats))))
  }
  
  private func checkIfFirstChatOverThreshold(_ offset: CGFloat) -> Effect<Action> {
    enum CheckAction: Hashable {
      case throttle
    }
    
    let statusBarHeight: CGFloat = UIApplication.statusBarHeight() ?? 0
    let navigationBarHeight: CGFloat = 44.0
    let topBarHeight = statusBarHeight + navigationBarHeight
    let threshold: CGFloat = 20.0
    
    if offset < topBarHeight + threshold {
      return .none
    }
    
    return .run { send in
      print("⬇️ 이전 채팅 불러오기 시작")
      let chats = try await chatDataProvider.fetchOldChats()
      await send(.internal(.chatDataProviderAction(.onReceiveNewChatType(chats))))
    }
    .debounce(id: CheckAction.throttle, for: .seconds(0.5), scheduler: DispatchQueue.main)
//    .throttle(id: CheckAction.throttle, for: .seconds(1.5), scheduler: DispatchQueue.main, latest: false)
    // Jin - TODO: TCA throttle 동작 제대로 안해서 일단 debounce로 대체한거 throttle로 변경하기
  }
}


import SwiftUI
import Kingfisher

struct ChatView: View {
  
  @State var store: StoreOf<ChatFeature>
  
  @Namespace private var bottomOfChatList
  @State private var isAtBottomPosition: Bool = false
  @State private var scrollViewProxy: ScrollViewProxy?
  

  var body: some View {
    ScrollViewReader { proxy in
      VStack(spacing: 0) {
        
        topNavigationBarView
        
        SwiftUI.List {
          ForEach(store.chats, id: \.id) { chatType in
            VStack(spacing: 0) {
              switch chatType {
              case .text(let vm, let topSpace, let bottomSpace):
                chatView(topSpace: topSpace, bottomSpace: bottomSpace) {
                  ChatTextBubbleView(viewModel: vm)
                }
                
              case .singleImage(let vm, let topSpace, let bottomSpace):
                chatView(topSpace: topSpace, bottomSpace: bottomSpace) {
                  SingleChatImageView(viewModel: vm)
                }
                
              case .multipleImages(let vm, let topSpace, let bottomSpace):
                chatView(topSpace: topSpace, bottomSpace: bottomSpace) {
                  MultipleChatImageView(viewModel: vm)
                }
                
              }
            }
            .id(chatType.id)
            .modifier(PlainListModifier())
            .overlay(chatType.id == store.chats.first?.id ? GeometryReader {
              Color.clear.preference(
                key: ViewOffsetKey.self,
                value: $0.frame(in: .global).origin.y
              )
            } : nil)
            .onPreferenceChange(ViewOffsetKey.self) {
              store.send(.view(.onFirstChatOffsetChange($0)))
            }
          }
          
          Spacer()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .modifier(PlainListModifier())
            .background(PND.DS.gray10)
          
          Color.clear
            .frame(height: 1)
            .modifier(PlainListModifier())
            .background(PND.DS.gray10)
            .onAppear       { isAtBottomPosition = true }
            .onDisappear()  { isAtBottomPosition = false }
            .id(bottomOfChatList)
        }
        .environment(\.defaultMinListRowHeight, 0)
        .listStyle(.plain)
        .background(PND.DS.gray10)
        .onAppear() {
          scrollViewProxy = proxy
        }
        .onChange(of: store.chats) { oldChats, newChats in
          // oldChats의 앞쪽에 새로운 채팅이 추가되면
          if let oldFirstID = oldChats.first?.id,
             let newFirstID = newChats.first?.id,
             oldFirstID != newFirstID {
            DispatchQueue.main.async {
              proxy.scrollTo(oldFirstID, anchor: .top)
            }
            return
          }
          
          if isAtBottomPosition {
            DispatchQueue.main.async {
              if oldChats.isEmpty {
                proxy.scrollTo(bottomOfChatList, anchor: .bottom)
              } else {
                withAnimation {
                  proxy.scrollTo(bottomOfChatList, anchor: .bottom)
                }
              }
            }
            return
          }
        }
      }
      .overlay(alignment: .bottom) {
        chatTextFieldView()
      }
      .overlay {
        
        ZStack {
          Color.black
            .opacity(0.5)
            .ignoresSafeArea()
            .isHidden(store.isMemberListViewPresented == false)
            .onTapGesture {
              store.send(.view(.onMemberListViewBlankAreaTap))
            }
          
          ChatMembersView(
            store: store.scope(
              state: \.chatMemberListState,
              action: ChatFeature.Action.chatMemberListAction
            )
          )
          .offset(x: store.isMemberListViewPresented ? 0 : 1000)
          .animation(.default, value: store.isMemberListViewPresented)
        }
      
      }
    }
    .navigationBarHidden(true)
    .isLoading(store.isUploadingImage)
    .onAppear {
      store.send(.view(.onAppear))
    }
  }
  
  @ViewBuilder
  private var topNavigationBarView: some View {
    HStack {
      Button {
        store.send(.view(.onBackButtonTap))
      } label: {
        Image(.iconUndo)
          .renderingMode(.template)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(PND.DS.commonBlack)
      }

      Spacer()
      
      VStack {
        Text(store.roomName)
          .font(.system(size: 20, weight: .bold))
        
        Text("예정된 이벤트 날짜 장소")
          .font(.system(size: 12, weight: .regular))
      }
      
      Spacer()
      
      Button {
        store.send(.view(.onMoreButtonTap))
      } label: {
        Image(.iconMenu)
          .renderingMode(.template)
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(PND.DS.commonBlack)
      }
    }
    .padding(.horizontal, 24)
    .padding(.bottom, 14)
  }
  
  
  
  @ViewBuilder
  private func chatTextFieldView() -> some View {
    HStack(spacing: 0) {
      
      PhotosPicker(
        selection: $store.state.selectedPhotoPickerItems,
        maxSelectionCount: 5,
        matching: .images
      ) {
        Image(systemName: "plus")
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(PND.DS.commonBlack)
      }
      .onChange(of: store.selectedPhotoPickerItems) { _, _ in
        store.send(.view(.onUserImageSelection))
      }
      
      Spacer().frame(width: 4)
      
      TextField(
        "채팅을 입력하세요",
        text: $store.textFieldText,
        onEditingChanged: { didBeginEditing in
          
        }
      )
      .font(.system(size: 16, weight: .regular))
      .tint(PND.DS.commonBlack)
      .padding(.horizontal, 8)
      .padding(.vertical, 10)
      .background(PND.DS.gray20)
      .clipShape(RoundedRectangle(cornerRadius: 4))
      .frame(height: 40)
      
      Button(action: {
        store.send(.view(.onSendChatButtonTap))
        scrollViewProxy?.scrollTo(
          bottomOfChatList,
          anchor: .bottom
        )
      }, label: {
        Image(systemName: "envelope")
          .frame(width: 24, height: 24)
          .foregroundStyle(store.textFieldText.isEmpty ? PND.DS.commonBlack : PND.DS.commonWhite)
          .padding(.all, 8)
          .background(store.textFieldText.isEmpty ? PND.DS.gray30 : PND.DS.gray90)
          .clipShape(RoundedRectangle(cornerRadius: 4))
          .frame(height: 40)
      })
    }
    .padding(.horizontal, 12)
    .modifier(PlainListModifier())
  }
  
  @ViewBuilder
  private func chatSpacer(height: CGFloat) -> some View{
    Rectangle()
      .fill(PND.DS.gray10)
      .frame(height: height)
      .modifier(PlainListModifier())
  }
  
  @ViewBuilder
  private func chatView(topSpace: CGFloat?, bottomSpace: CGFloat?, @ViewBuilder view: (() -> some View)) -> some View {
    if let topSpace {
      chatSpacer(height: topSpace)
    }
    view()
    if let bottomSpace {
      chatSpacer(height: bottomSpace)
    }
  }
}


// MARK: - ViewOffsetKey

extension ChatView {
  struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
      value += nextValue()
    }
  }
}


// MARK: - SingleChatImageView

struct SingleChatImageViewModel: Equatable {
  
  let id: String = UUID().uuidString
  
  let media: PND.Media
  
  let isMyChat: Bool
}


struct SingleChatImageView: View {
  
  var viewModel: SingleChatImageViewModel
  
  @State private var isChatImageViewPresented: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      if viewModel.isMyChat {
        myImageView
      } else {
        otherImageView
      }
    }
    .modifier(PlainListModifier())
    .background(PND.DS.gray10)
    .fullScreenCover(
      isPresented: $isChatImageViewPresented,
      onDismiss: {
        isChatImageViewPresented = false
      },
      content: {
        ChatImageViewer(medias: [viewModel.media])
      }
    )
  }
  
  private var myImageView: some View {
    HStack(spacing: 0) {
      Spacer(minLength: 72)
      
      KFImage.url(URL(string: viewModel.media.url ?? ""))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .centerCropImage(width: UIScreen.fixedScreenSize.width / CGFloat(4) * CGFloat(2.7), height: UIScreen.fixedScreenSize.width / CGFloat(4) * CGFloat(2.7))
        .clipShape(RoundedRectangle(cornerRadius: CGFloat(20)))
      
      DefaultSpacer(axis: .horizontal)
    }
  }
  
  private var otherImageView: some View {
    HStack(alignment: .top, spacing: 0) {
      
      profileView
      Spacer().frame(width: 12)
      
      VStack(alignment: .leading, spacing: 0) {
        
        Text("호두 언니")
          .font(.system(size: 14, weight: .medium))
        
        Spacer().frame(height: 4)
        
        KFImage.url(URL(string: viewModel.media.url ?? ""))
          .placeholder {
            ProgressView()
          }
          .resizable()
          .centerCropImage(width: UIScreen.fixedScreenSize.width / CGFloat(4) * CGFloat(2.7), height: UIScreen.fixedScreenSize.width / CGFloat(4) * CGFloat(2.7))
          .clipShape(RoundedRectangle(cornerRadius: CGFloat(20)))
        
      }
    }
  }
  
  private var profileView: some View {
    HStack(spacing: 0) {
      KFImage.url(MockDataProvider.randomePetImageUrl)
        .resizable()
        .frame(width: 36, height: 36)
        .clipShape(Circle())
        .padding(.leading, PND.Metrics.defaultSpacing)
    }
  }
}


// MARK: - MultipleChatImageView

struct MultipleChatImageViewModel: Equatable {
  
  let id: String = UUID().uuidString
  
  var medias: [PND.Media]
  
  let firstImageUrlString: String
  let secondImageUrlString: String
  
  let additionalImageCount: Int
  
  let isMyChat: Bool
  
  init(medias: [PND.Media], isMyChat: Bool) {
    self.additionalImageCount = medias.count - 2
    self.medias = medias
    self.isMyChat = isMyChat
    
    var tempMedias: [PND.Media] = medias
    
    self.firstImageUrlString = tempMedias.removeFirst().url ?? ""
    self.secondImageUrlString = tempMedias.removeFirst().url ?? ""
  }
}

struct MultipleChatImageView: View {
  
  var viewModel: MultipleChatImageViewModel
  
  @State private var isChatImageViewPresented: Bool = false
  
  var body: some View {
    VStack(spacing: 0) {
      if viewModel.isMyChat {
        myImageView
      } else {
        otherImageView
      }
    }
    .modifier(PlainListModifier())
    .onTapGesture {
      isChatImageViewPresented = true
    }
    .background(PND.DS.gray10)
    .fullScreenCover(
      isPresented: $isChatImageViewPresented,
      onDismiss: {
        isChatImageViewPresented = false
      },
      content: {
        ChatImageViewer(medias: viewModel.medias)
      }
    )
  }
  
  private var myImageView: some View {
    HStack(spacing: 4) {
      
      Spacer(minLength: 72)
      
      KFImage.url(URL(string: viewModel.firstImageUrlString))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .centerCropImage(width: CGFloat(125), height: CGFloat(125))
        .scaledToFill()
        .clipShape(RoundedRectangle(cornerRadius: CGFloat(20)))
      
      KFImage.url(URL(string: viewModel.secondImageUrlString))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .centerCropImage(width: CGFloat(125), height: CGFloat(125))
        .if(viewModel.additionalImageCount >= 1, { view in
          view
            .overlay(
              ZStack {
                Color
                  .black
                  .opacity(0.5)
                
                Text("+\(viewModel.additionalImageCount)")
                  .font(.system(size: 20, weight: .bold))
                  .foregroundStyle(PND.DS.commonWhite)
              }
            )
        })
        .clipShape(RoundedRectangle(cornerRadius: CGFloat(20)))
      
      DefaultSpacer(axis: .horizontal)
    }
  }
  
  private var otherImageView: some View {
    HStack(alignment: .top, spacing: 0) {
      
      profileView
      Spacer().frame(width: 12)
      
      VStack(alignment: .leading, spacing: 0) {
        
        Text("호두 언니")
          .font(.system(size: 14, weight: .medium))
        
        Spacer().frame(height: 4)
        
        HStack(spacing: 4) {
          KFImage.url(URL(string: viewModel.firstImageUrlString))
            .placeholder {
              ProgressView()
            }
            .resizable()
            .centerCropImage(width: CGFloat(125), height: CGFloat(125))
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(20)))
          
          KFImage.url(URL(string: viewModel.secondImageUrlString))
            .placeholder {
              ProgressView()
            }
            .resizable()
            .centerCropImage(width: CGFloat(125), height: CGFloat(125))
            .if(viewModel.additionalImageCount >= 1, { view in
              view
                .overlay(
                  ZStack {
                    Color
                      .black
                      .opacity(0.5)
                    
                    Text("+\(viewModel.additionalImageCount)")
                      .font(.system(size: 20, weight: .bold))
                      .foregroundStyle(PND.DS.commonWhite)
                  }
                )
            })
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(20)))
        }
      }
    }
  }
  
  private var profileView: some View {
    HStack(spacing: 0) {
      KFImage.url(MockDataProvider.randomePetImageUrl)
        .resizable()
        .frame(width: 36, height: 36)
        .clipShape(Circle())
        .padding(.leading, PND.Metrics.defaultSpacing)
    }
  }
}


// MARK: - ChatTextBubbleView

struct ChatTextBubbleViewModel: Equatable {
  let id: String = UUID().uuidString
  let body: String
  let isMyChat: Bool
}


struct ChatTextBubbleView: View {
  
  var viewModel: ChatTextBubbleViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      if viewModel.isMyChat {
        myChatTextView
      } else {
        otherChatTextView
      }
    }
    .background(PND.DS.gray10)
    .modifier(PlainListModifier())
  }
  
  var myChatTextView: some View {
    HStack(alignment: .center, spacing: 0) {
      Spacer(minLength: 72)
      Text(viewModel.body)
        .multilineTextAlignment(.leading)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .foregroundStyle(PND.DS.commonWhite)
        .background(PND.DS.primary)
        .clipShape(
          .rect(
            topLeadingRadius: 20 ,
            bottomLeadingRadius: 20,
            bottomTrailingRadius: 20,
            topTrailingRadius: 0
          )
        )
      
      DefaultSpacer(axis: .horizontal)
    }
  }
  
  var otherChatTextView: some View {
    HStack(alignment: .top, spacing: 0) {
      
      profileView
      
      Spacer().frame(width: 12)
      
      VStack(alignment: .leading, spacing: 0) {
        
        Text("호두 언니")
          .font(.system(size: 14, weight: .medium))
        
        Spacer().frame(height: 4)
        Text(viewModel.body)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.horizontal, 16)
          .padding(.vertical, 10)
          .foregroundStyle(PND.DS.commonBlack)
          .background(PND.DS.gray20)
          .clipShape(
            .rect(
              topLeadingRadius: 0,
              bottomLeadingRadius: 20,
              bottomTrailingRadius: 20,
              topTrailingRadius: 20
            )
          )
        
      }
      
      Spacer(minLength: PND.Metrics.defaultSpacing)
    }
  }
  
  
  var profileView: some View {
    HStack(spacing: 0) {
      KFImage.url(MockDataProvider.randomePetImageUrl)
        .resizable()
        .frame(width: 36, height: 36)
        .clipShape(Circle())
        .padding(.leading, PND.Metrics.defaultSpacing)
      
    }
  }
}


//
//#Preview {
//  ChatView(store: .init(initialState: .init(), reducer: { ChatFeature()}))
//}


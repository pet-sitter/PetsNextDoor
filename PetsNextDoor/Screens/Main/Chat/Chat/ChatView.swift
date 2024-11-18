//
//  ChatView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/24.
//

import ComposableArchitecture
import SwiftUI
import PhotosUI

enum ChatViewType: Equatable, Identifiable {

	case text(ChatTextBubbleViewModel)
  case singleImage(SingleChatImageViewModel)
  case multipleImages(MultipleChatImageViewModel)
  case spacer(height: CGFloat)
	
	var id: String {
		switch self {
		case .text(let vm):
			return vm.id
      
    case .singleImage(let vm):
      return vm.id
      
    case .multipleImages(let vm):
      return vm.id
      
    case .spacer:
      return UUID().uuidString
		}
	}
}


@Reducer
struct ChatFeature: Reducer {
  
  @Dependency(\.chatDataProvider) var chatDataProvider
  
  @ObservableState
	struct State: Equatable {

		var chats: [ChatViewType] = []
    
    var textFieldText: String = ""
    
    
    var isUploadingImage: Bool = false
    
    var selectedPhotoPickerItems: [PhotosPickerItem] = []
    

		var connectivityState = ConnectivityState.disconnected
		enum ConnectivityState: String {
			case connecting
			case connected
			case disconnected
		}
  }
	

  enum Action: RestrictiveAction, BindableAction {
 
    enum ViewAction: Equatable {
      case onAppear
      case onMemberListButtonTap
      
      // ChatTextField
      case onSendChatButtonTap
      case onUserImageSelection
    }
    
    enum InternalAction: Equatable {
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
  }
	
	enum CancellableID {
		
	}
	
	init() {
		
	}
	
  var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			
			switch action {
				
        // View
      case .view(.onAppear):
        return observeChatActionStream()
//        return .run { send in
//          
//          let room = try? await chatDataProvider.fetchRoomInfo()
//          
//          
//          observeChatActionStream()
//          
//        } catch: { error, send in
//          print("❌ error onAppear : \(error.asMoyaError.debugDescription)")
//        }
        
      case .view(.onMemberListButtonTap):
        return .none

				// Internal
				
			case .internal(.chatDataProviderAction(.onConnect)):
				return .none
				
			case .internal(.chatDataProviderAction(.onDisconnect)):
				return .none
				
			case .internal(.chatDataProviderAction(.onReceiveNewChatType(let chatType))):
        state.chats.append(contentsOf: chatType)
				return .none
				
      case .internal(.setIsUploadingImage(let isLoading)):
        state.isUploadingImage = isLoading
        return .none
        
      case .internal(.setSelectedPhotoPickerItems(let pickerItems)):
        state.selectedPhotoPickerItems = pickerItems
        return .none

      case .view(.onSendChatButtonTap):
        // empty, 숫자 초과 등 검사 로직 추가
        guard state.textFieldText.isEmpty == false else { return .none }
        
        chatDataProvider.sendChat(text: state.textFieldText)
        state.textFieldText = ""
        return .none
        
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
      }
			
			
			
			return .none
		}
	}
  

	

	private func observeChatActionStream() -> Effect<Action> {
		return .run { send in
			
			let actions = chatDataProvider.observeChatActionStream()
			
			await withThrowingTaskGroup(of: Void.self) { group in
				
				for await action in actions {
					group.addTask { await send(.internal(.chatDataProviderAction(action))) }
					
					switch action {
					case .onConnect:
						break
						 
					case .onDisconnect:
						break
						
					default: break
					}
				}
			}
		}
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
      SwiftUI.List {
        ForEach(store.chats, id: \.id) { chatType in
          switch chatType {
          case .text(let vm):
            ChatTextBubbleView(viewModel: vm)
            
          case .singleImage(let vm):
            SingleChatImageView(viewModel: vm)
            
          case .multipleImages(let vm):
            MultipleChatImageView(viewModel: vm)
            
          case .spacer(let height):
            chatSpacer(height: height)
          }
        }
        
        Spacer()
          .frame(height: 50)
          .modifier(PlainListModifier())
        
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
      .onChange(of: store.chats) { _, _ in
        if isAtBottomPosition {
          DispatchQueue.main.async {
            withAnimation() {
              proxy.scrollTo(bottomOfChatList, anchor: .bottom)
            }
          }
        }
      }
      .overlay(alignment: .bottom) {
        chatTextFieldView()
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .topBarLeading) {
        Text("채팅")
          .foregroundStyle(PND.Colors.commonBlack.asColor)
          .font(.system(size: 20, weight: .bold))
        
        HStack(spacing: 2) {
          
          Image(systemName: "person.fill")
            .resizable()
            .frame(width: 9, height: 9)
          
          Text("10")
            .font(.system(size: 12, weight: .bold))
        }
        .foregroundStyle(PND.Colors.gray50.asColor)
        .frame(height: 23)
        .padding(.horizontal, 8)
        .background(PND.Colors.gray20.asColor)
        .clipShape(.capsule)
      }
      
      ToolbarItemGroup(placement: .topBarTrailing) {
        
        Menu {
          Button {
            
          } label: {
            HStack {
              Text("글 목록")
              Image(.iconPen)
                .resizable()
                .frame(width: 20, height: 20)
            }
          }
          
          Button {
            store.send(.view(.onMemberListButtonTap))
          } label: {
            HStack {
              Text("멤버 관리")
              Image(.iconUserBlack)
                .resizable()
                .frame(width: 20, height: 20)
            }
          }

        } label: {
          Image(.iconMenu)
            .rotationEffect(.degrees(90))
            .foregroundStyle(PND.Colors.commonBlack.asColor)
        }
      }
    }
    .isLoading(store.isUploadingImage)
    .onAppear {
      store.send(.view(.onAppear))
    }
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


}



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



#Preview {
  ChatView(store: .init(initialState: .init(), reducer: { ChatFeature()}))
}


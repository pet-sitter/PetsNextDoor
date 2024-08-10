//
//  ChatView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/24.
//

import ComposableArchitecture
import SwiftUI

enum ChatViewType: Equatable, Identifiable {

	case text(ChatTextBubbleViewModel)
  case spacer(height: CGFloat)
	
	var id: String {
		switch self {
		case .text(let vm):
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
      
      // ChatTextField
      case onSendChatButtonTap
    }
    
    enum InternalAction: Equatable {
			case chatDataProviderAction(ChatDataProvider.Action)
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

				// Internal
				
			case .internal(.chatDataProviderAction(.onConnect)):
				return .none
				
			case .internal(.chatDataProviderAction(.onDisconnect)):
				return .none
				
			case .internal(.chatDataProviderAction(.onReceiveNewChatType(let chatType))):
        state.chats.append(contentsOf: chatType)
				return .none
				

      case .view(.onSendChatButtonTap):
        // empty, 숫자 초과 등 검사 로직 추가
        guard state.textFieldText.isEmpty == false else { return .none }
        
        chatDataProvider.sendChat(text: state.textFieldText)
        state.textFieldText = ""
        return .none

				
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
            
          case .spacer(let height):
            chatSpacer(height: height)
          }
        }
        
        Spacer()
          .frame(height: PND.Metrics.defaultSpacing)
        
        Color.clear
          .frame(height: 1)
          .modifier(PlainListModifier())
          .onAppear       { isAtBottomPosition = true }
          .onDisappear()  { isAtBottomPosition = false }
          .id(bottomOfChatList)
      }
      .environment(\.defaultMinListRowHeight, 0)
      .listStyle(.plain)
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
    .onAppear {
      store.send(.view(.onAppear))
    }
  }
  

  @ViewBuilder
  private func chatTextFieldView() -> some View {
    HStack(spacing: 0) {
      
      Button(action: {
        
      }, label: {
        Image(systemName: "plus")
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundStyle(PND.DS.commonBlack)
      })

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
      .fill(Color.white)
      .frame(height: height)
      .modifier(PlainListModifier())
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



//#Preview {
//  ChatView(store: .init(initialState: .init(), reducer: { ChatFeature()}))
//}


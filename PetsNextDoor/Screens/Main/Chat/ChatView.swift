//
//  ChatView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/24.
//

import ComposableArchitecture




enum ChatType: Equatable, Identifiable {

	case text(ChatTextBubbleViewModel)
//	case image
	
	var id: String {
		switch self {
		case .text(let vm):
			return vm.id
		}
	}
}



@Reducer
struct ChatFeature: Reducer {
  
  @Dependency(\.chatDataProvider) var chatDataProvider
  
  @ObservableState
	struct State: Equatable {

		var chats: [ChatType] = []

  }
  
  enum Action: RestrictiveAction, BindableAction {

    enum ViewAction: Equatable {
      case onAppear
    }
    
    enum InternalAction: Equatable {
			case setInitialChatVMs([ChatTextBubbleViewModel])
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
			
			switch action {
				
				// View
			case .view(.onAppear):
				return .send(.internal(.setInitialChatVMs(MockDataProvider.chatBubbleViewModels)))
				
				// Internal
				
			case .internal(.setInitialChatVMs(let chatVMs)):
//				state.chatViewModels = chatVMs
				return .none
				
			case .internal:
				break
				
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
	
	
	
	
	
	
	
}













import SwiftUI
import Kingfisher

struct ChatView: View {
  
  @State var store: StoreOf<ChatFeature>

	var body: some View {
		ScrollViewReader { proxy in
			
			topNavigationBarView
			
			SwiftUI.List {
				ForEach(store.chats, id: \.id) { chatType in
					switch chatType {
					case .text(let vm):
						ChatTextBubbleView(viewModel: vm)
					}
			

				}
				
		
				
			}
      .environment(\.defaultMinListRowHeight, 0)
      .listStyle(.plain)
    }
    .onAppear {
      store.send(.view(.onAppear))
//
//      ChatClient.shared.connect(username: "kevinkim2586")
//          ChatClient.shared.receiveMessage { username, text, id in
//            print("✅ receiveMessage: \(username)")
////              self.receiveMessage(username: username, text: text, id: id)
//          }
//          ChatClient.shared.receiveNewUser { username, users in
//            print("✅ receiveNewUser: \(username)")
////              self.receiveNewUser(username: username, users: users)
//          }
    }
  }
  

  
  
  private var topNavigationBarView: some View {
    HStack {
      Spacer().frame(width: PND.Metrics.defaultSpacing)

			Button {
				
			} label: {
				Image(systemName: "chevron.left")
					.frame(width: 24, height: 24)
					.foregroundStyle(PND.Colors.commonBlack.asColor)
			}
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


struct ChatTextBubbleViewModel: Equatable {
	
	var id: String = UUID().uuidString

	
	let body: String
	let isMyChat: Bool

}


struct ChatTextBubbleView: View {
	
	var viewModel: ChatTextBubbleViewModel
	
	var body: some View {
		VStack(spacing: 0) {
			chatTextView
		}
		.background(.white)
		.listRowSeparator(.hidden)
		.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

	}
	
	var chatTextView: some View {
		HStack(alignment: .top, spacing: 0) {
//			if viewModel.isMyChat == false {
//				profileView
//			}
//		
			Text(viewModel.body)
				.multilineTextAlignment(.leading)
				.lineLimit(nil)
				.fixedSize(horizontal: false, vertical: true)
				.foregroundStyle(viewModel.isMyChat ? PND.DS.commonWhite : PND.DS.commonBlack)
				.padding(.horizontal, 16)
				.padding(.vertical, 10)
				.background(viewModel.isMyChat ? PND.DS.primary : PND.DS.gray20)
				.clipShape(
					.rect(
						topLeadingRadius: viewModel.isMyChat ? 20 : 0,
						bottomLeadingRadius: 20,
						bottomTrailingRadius: 20,
						topTrailingRadius: viewModel.isMyChat ? 0 : 20
					)
				)
				.padding(.top, viewModel.isMyChat ? 5 : 30)
				.padding(.bottom, viewModel.isMyChat ? 24 : 40)
				.modifier(ChatBubbleSpaceModifier(isMyChat: viewModel.isMyChat))
				.overlay(
					alignment: .topLeading,
					content: {
						if !viewModel.isMyChat {
							profileView
								.offset(x: -10, y: -10)
						}
					})
				
			
		}
	}
	
	var profileView: some View {
		HStack(spacing: 0) {
			KFImage.url(MockDataProvider.randomePetImageUrl)
				.resizable()
				.frame(width: 36, height: 36)
				.clipShape(Circle())
				.padding(.leading, PND.Metrics.defaultSpacing)
			
			Text("호두 언니")
		}
	}
}


struct ChatBubbleSpaceModifier: ViewModifier {
	
	let isMyChat: Bool
	
	func body(content: Content) -> some View {
		HStack(spacing: 0) {
			
			if isMyChat {
				Spacer(minLength: 72)
			} else {
				Spacer().frame(width: 42)
			}
			
			content
			
			if isMyChat {
				DefaultSpacer(axis: .horizontal)
			} else {
				Spacer(minLength: PND.Metrics.defaultSpacing)
			}
		}
	}
}



#Preview {
  ChatView(store: .init(initialState: .init(), reducer: { ChatFeature()}))
}

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
  
  @Dependency(\.chatDataProvider) var chatDataProvider
  
  @ObservableState
	struct State: Equatable {

		var chatViewModels: [ChatBubbleViewModel] = []
  }
  
  enum Action: RestrictiveAction, BindableAction {

    enum ViewAction: Equatable {
      case onAppear
    }
    
    enum InternalAction: Equatable {
			case setInitialChatVMs([ChatBubbleViewModel])
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
				state.chatViewModels = chatVMs
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

struct ChatView: View {
  
  @State var store: StoreOf<ChatFeature>
  

	var body: some View {
		ScrollViewReader { proxy in
			
			topNavigationBarView
			
			SwiftUI.List {
				ForEach($store.chatViewModels, id: \.id) { vm in
					ChatBubbleView(viewModel: vm)
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


struct ChatBubbleViewModel: Equatable {
	
	var id: String = UUID().uuidString
	let chatBubbleType: BubbleType = .text
	
	let body: String
	let isMyChat: Bool

	enum BubbleType {
		case text
	}
}

struct ChatBubbleView: View {
	
	@Binding var viewModel: ChatBubbleViewModel
	
	var body: some View {
		VStack(spacing: 0) {
			
			switch viewModel.chatBubbleType {
			case .text:
				chatTextView
			}

		}
		.background(.white)
		.listRowSeparator(.hidden)
		.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

	}
	
	var chatTextView: some View {
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
			.padding(.vertical, 10)
			.modifier(ChatBubbleSpaceModifier(isMyChat: viewModel.isMyChat))
	}
}


struct ChatBubbleSpaceModifier: ViewModifier {
	
	let isMyChat: Bool
	
	func body(content: Content) -> some View {
		HStack(spacing: 0) {
			
			if isMyChat {
				Spacer(minLength: 72)
			} else {
				Spacer().frame(width: 40)
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

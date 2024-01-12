//
//  WriteUrgentPostView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/08.
//

import SwiftUI
import ComposableArchitecture

struct WriteUrgentPostFeature: Reducer {
  
  struct State: Equatable {
    
    var title: String = ""
    var content: String = ""
    
    var isBottomButtonEnabled: Bool   = false
    var photoPickerIsPresented: Bool  = false
    var selectedUserImage: UIImage?
    
    fileprivate var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable {
    
    case titleDidChange(String)
    case contentDidChange(String)
    case profileImageDidTap
    case userImageDidChange(UIImage)
    case setBottomButtonEnabled(Bool)
    
    // Internal Cases
    case _routeAction(Router<PND.Destination>.Action)
  }
  
  var body: some Reducer<State,Action> {
    
    Scope(
      state: \.router,
      action: /Action._routeAction
    ) {
      Router<PND.Destination>()
    }
    
    Reduce { state, action in
      switch action {
        
      case .titleDidChange(let title):
        state.title = title
        return .none
        
      case .contentDidChange(let content):
        
        return .none
       
      case .profileImageDidTap:
        state.photoPickerIsPresented = true
        return .none
        
      case .userImageDidChange(let image):
        state.photoPickerIsPresented = false
        state.selectedUserImage = image
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        return .none
        
      default:
        return .none
      }
    }
  }
}


struct WriteUrgentPostView: View {
  
  @State var title: String = ""
  @State var content: String = ""
  
  let store: StoreOf<WriteUrgentPostFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        
        Spacer().frame(height: 18)
        
        TextField(
          "돌봄 급구 제목을 입력해주세요.",
          text: viewStore.binding(
            get: \.title,
            send: { .titleDidChange($0) }
          )
        )
        .font(.system(size: 24, weight: .regular))
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        
        Spacer().frame(height: 20)
        
        Text("상세설명")
          .padding(.leading, PND.Metrics.defaultSpacing)
          .font(.system(size: 16, weight: .bold))
        
        Spacer().frame(height: 12)
        
        TextEditorWithPlaceholder(
          text: viewStore.binding(
            get: \.content,
            send: { .contentDidChange($0) }
          ),
          placeholder: "요청하고 싶은 돌봄에 대해 상세히 설명해주세요. 돌봄 시 반드시 숙지해야하는 주의사항을 적어주세요. \n\n ex) 실외배변을 위해 매일 2번 이상의 짧은 산책 필수"
        )
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        .frame(height: UIScreen.fixedScreenSize.height / 3)

        SelectImagesHorizontalView(viewModel: .init(maxImagesCount: 5))
        
        Spacer()
       
        BaseBottomButton_SwiftUI(
          isEnabledColor: PND.Colors.primary.asColor,
          title: "작성완료",
          isEnabled: viewStore.binding(
            get: \.isBottomButtonEnabled,
            send: { .setBottomButtonEnabled($0) }
          )
        )
  
      }
    }
  }
}

#Preview {
  WriteUrgentPostView(store: .init(initialState: .init(), reducer: WriteUrgentPostFeature()))
}

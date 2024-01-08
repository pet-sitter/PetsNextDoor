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
    var isBottomButtonEnabled: Bool   = true
    var photoPickerIsPresented: Bool  = false
    var selectedUserImage: UIImage?
    
    fileprivate var router: Router<PND.Destination>.State = .init()
  }
  
  enum Action: Equatable {
    
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
        
        TextField("돌봄 급구 제목을 입력해주세요.", text: $title)
          .font(.system(size: 24, weight: .regular))
          .padding(.horizontal, PND.Metrics.defaultSpacing)
        
        Spacer().frame(height: 20)
        
        Text("상세설명")
          .padding(.leading, PND.Metrics.defaultSpacing)
          .font(.system(size: 16, weight: .bold))
        
        Spacer().frame(height: 12)
        
        TextEditorWithPlaceholder(
          text: $content,
          placeholder: "요청하고 싶은 돌봄에 대해 상세히 설명해주세요. 돌봄 시 반드시 숙지해야하는 주의사항을 적어주세요. \n\n ex) 실외배변을 위해 매일 2번 이상의 짧은 산책 필수"
        )
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        .frame(height: UIScreen.fixedScreenSize.height / 3)

        SelectImagesHorizontalView(viewModel: .init(maxImagesCount: 5))
        
        Spacer()
       
        BaseBottomButton_SwiftUI(
          isEnabledColor: PND.Colors.primary.asColor,
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

struct BaseBottomButton_SwiftUI: View {
  
  var isEnabledColor: Color = PND.Colors.commonBlack.asColor
  @Binding var isEnabled: Bool
  @State var isDisabled: Bool = false
  
  
  var body: some View {
    Button(action: {
      
    }, label: {
      Rectangle()
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        .frame(height: 60)
        .cornerRadius(4,)
        .foregroundStyle(
          isEnabled ? isEnabledColor : PND.Colors.gray30.asColor
        )
        .disabled(isEnabled ? false : true)
        .overlay(
          Text("완료")
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.white)
        )
    })
  }
}


struct TextEditorWithPlaceholder: View {
  
  @Binding var text: String
  let placeholder: String
  
  var body: some View {
    ZStack(alignment: .leading) {
      if text.isEmpty {
        VStack {
          Text(placeholder)
            .padding(.top, 10)
            .padding(.leading, 6)
            .foregroundStyle(.black)
          Spacer()
        }
      }
      
      VStack {
        TextEditor(text: $text)
          .font(.system(size: 16, weight: .regular))
          .opacity(text.isEmpty ? 0.7 : 1)
        Spacer()
      }
    }
  }
}

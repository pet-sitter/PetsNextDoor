//
//  WriteUrgentPostView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/08.
//

import SwiftUI
import ComposableArchitecture

struct WriteUrgentPostFeature: Reducer {
  
  @Dependency(\.sosPostService) var postService
  @Dependency(\.mediaService) var mediaService
  
  struct State: Hashable {
    var isLoading: Bool = false
    var title: String = ""
    var content: String = ""
    var isBottomButtonEnabled: Bool   = false
    var selectedImageDatas: [Data] = []
    var urgentPostModel: PND.UrgentPostModel
  }
  
  enum Action: Equatable {
      
    case titleDidChange(String)
    case contentDidChange(String)
    case onImageDataChange([Data])
    case onBottomButtonTap
    case setBottomButtonEnabled(Bool)
    
    // Internal Cases
    case _setIsLoading(Bool)
    case _setImageIds([Int])
    case _validateInput
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      switch action {
        
      case .titleDidChange(let title):
        state.title = title
        state.urgentPostModel.title = title
        return .send(._validateInput)
        
      case .contentDidChange(let content):
        state.content = content
        state.urgentPostModel.content = content
        return .send(._validateInput)
        
      case .onImageDataChange(let imageDatas):
        state.selectedImageDatas = imageDatas
        return .none
        
      case .onBottomButtonTap:
        return .run { [state] send in
        
          await send(._setIsLoading(true))
          
          let uploadResponse = try await mediaService.uploadImages(imageDatas: state.selectedImageDatas)
        
          await send(._setImageIds(uploadResponse.map(\.id)))
          
          let postResult = try? await postService.postSOSPost(model: state.urgentPostModel)
          
          await send(._setIsLoading(false))
  
        } catch: { error, send in
          await send(._setIsLoading(false))
          Toast.shared.present(title: "업로드 실패", symbol: "xmark")
        }
        
      case ._setImageIds(let imageIds):
        state.urgentPostModel.imageIds = imageIds
        return .none
        
      case ._validateInput:
        if !state.title.isEmpty, !state.content.isEmpty {
          return .send(.setBottomButtonEnabled(true))
        } else {
          return .send(.setBottomButtonEnabled(false ))
        }
        
      case ._setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      case .setBottomButtonEnabled(let isEnabled):
        state.isBottomButtonEnabled = isEnabled
        return .none
        

      }
    }
  }
}


struct WriteUrgentPostView: View {
  
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

        SelectImagesHorizontalView(
          maxImagesCount: 5,
          selectedImageDatas: viewStore.binding(
            get: \.selectedImageDatas,
            send: { .onImageDataChange($0) }
          )
        )

        Spacer()
       
        BaseBottomButton_SwiftUI(
          isEnabledColor: PND.Colors.primary.asColor,
          title: "작성완료",
          isEnabled: viewStore.binding(
            get: \.isBottomButtonEnabled,
            send: { .setBottomButtonEnabled($0) }
          )
        )
        .onTapGesture {
          viewStore.send(.onBottomButtonTap)
        }
      }
    }
  }
}

//#Preview {
//  WriteUrgentPostView(store: .init(initialState: .init(urgentPostModel: .default()), reducer: WriteUrgentPostFeature()))
//}

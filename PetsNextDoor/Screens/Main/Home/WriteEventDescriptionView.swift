//
//  WriteEventDescriptionView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 11/7/24.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct WriteEventDescriptionFeature: Reducer {
  
  @Dependency(\.mediaService) var mediaService
  @Dependency(\.eventService) var eventService
  
  @ObservableState
  struct State: Equatable {
    var eventUploadModel: PND.EventUploadModel
    var eventTitle: String = ""
    var eventDescription: String = ""
    var selectedImageDatas: [Data] = []
    var isBottomButtonEnabled: Bool = false
    var isLoading: Bool = false
  }
  
  enum Action: BindableAction {
    case onBottomButtonTap
    case setIsLoading(Bool)
    case onEventUploadComplete
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State,Action> {
    BindingReducer()
    Reduce { state, action in
      
      switch action {
      case .binding(\.eventDescription):
        state.isBottomButtonEnabled = state.eventDescription.isEmpty ? false : true
        state.eventUploadModel.eventDescription = state.eventDescription
        return .none
        
      case .binding(\.eventTitle):
        state.eventUploadModel.eventTitle = state.eventTitle
        return .none
        
      case .setIsLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      case .onBottomButtonTap:
        return .run { [state] send in
          
          await send(.setIsLoading(true))
          
          // 먼저 이미지 업로드
          
          if let firstImageData = state.selectedImageDatas.first {
            
            var uploadModel = state.eventUploadModel
            
            let uploadImageResponse = try await mediaService.uploadImage(
              imageData: firstImageData,
              imageName: "eventDescription-\(UUID().hashValue)"
            )
            
            uploadModel.eventMediaId = uploadImageResponse.id
            
            let _ = try await eventService.postEvent(model: uploadModel.asEvent())
            
            // 채팅방 생성 API 쏴야함

            await send(.setIsLoading(false))
            await send(.onEventUploadComplete)
          }

          
        } catch: { error, send in
          await send(.setIsLoading(false))
          PNDLogger.default.error("failed uploading event model")
        }
        
      default:
        return .none
      }
    }
  }
}

struct WriteEventDescriptionView: View {
  
  @State var store: StoreOf<WriteEventDescriptionFeature>
  
  
  var body: some View {
    VStack(alignment: .leading) {
      
      Spacer().frame(height: 18)
      
      TextField(
        "이벤트 이름을 입력해주세요",
        text: $store.eventTitle
      )
      .font(.system(size: 24, weight: .regular))
      .padding(.horizontal, PND.Metrics.defaultSpacing)
      .tint(PND.DS.primary)
      
      Spacer().frame(height: 20)
      
      Text("상세설명")
        .padding(.leading, PND.Metrics.defaultSpacing)
        .font(.system(size: 16, weight: .bold))
      
      Spacer().frame(height: 12)
      
      TextEditorWithPlaceholder(
        text: $store.eventDescription,
        placeholder: "이벤트에 대해 좀 더 자세히 설명해주세요.\nex) 반려동물 종류, 주요활동 내용, 활동 지역, 활동 주기 등"
      )
      .padding(.horizontal, PND.Metrics.defaultSpacing)
      .frame(height: UIScreen.fixedScreenSize.height / 3)
      
      SelectImagesHorizontalView(
        maxImagesCount: 1,
        selectedImageDatas: $store.selectedImageDatas
      )
      
      Spacer()
      
      
      BaseBottomButton_SwiftUI(
        title: "작성 완료",
        isEnabled: $store.isBottomButtonEnabled
      )
      .onTapGesture {
        store.send(.onBottomButtonTap)
      }

    }
    .isLoading(store.isLoading)
  }
}

#Preview {
  WriteEventDescriptionView(store: .init(initialState: .init(eventUploadModel: .init()), reducer: { WriteEventDescriptionFeature() }))
}

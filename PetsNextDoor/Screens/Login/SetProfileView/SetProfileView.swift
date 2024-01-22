//
//  SetProfileView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/22.
//

import SwiftUI
import ComposableArchitecture

struct SetProfileView: View {
  
  let store: StoreOf<SetProfileFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical) {
        VStack {
          Spacer()
            .frame(height: 20)
     
          // 임시
          SelectImagesHorizontalView(
            maxImagesCount: 1,
            selectedImageDatas: viewStore.binding(
              get: \.selectedUserImageData,
              send: { .onImageDataChange($0) }
            )
          )
          
//          Rectangle()
//            .fill(PND.Colors.gray20.asColor)
//            .frame(width: 100, height: 100)
//            .cornerRadius(4)
//            .overlay {
//              Image(systemName: "photo")
//                .frame(width: 24, height: 24)
//            }
          
          Spacer()
            .frame(height: 30)
          
          
          TextField(
            "이름",
            text: viewStore.binding(
              get: \.nicknameText,
              send: { .textDidChange($0) }
            )
          )
          .font(.system(size: 20, weight: .medium))
          .padding(8)
          .frame(width: .infinity)
          .frame(height: 54)
          .padding(.horizontal, PND.Metrics.defaultSpacing)
          .multilineTextAlignment(.leading)
          .background(.clear)
          .tint(PND.Colors.primary.asColor)
          
          Rectangle()
            .padding(.horizontal, PND.Metrics.defaultSpacing)
            .frame(height: 1)
            .foregroundStyle(PND.Colors.gray50.asColor)
          
          Spacer().frame(height: 20)
          
          if !viewStore.myPetCellViewModels.isEmpty {
            ForEach(viewStore.myPetCellViewModels, id: \.id) { cellVM in
              SelectPetView(viewModel: cellVM)
            }
          }
          
          Spacer().frame(height: 20)
          
          RoundedRectangle(cornerRadius: 4)
            .frame(height: 54)
            .padding(.horizontal, PND.Metrics.defaultSpacing)
            .foregroundStyle(PND.Colors.gray20.asColor)
            .overlay(
              Button("반려동물", systemImage: "plus") {
                viewStore.send(.didTapAddPetButton)
              }
                .foregroundStyle(.black)
            )
          
          Spacer()
          
          BaseBottomButton_SwiftUI(
            title: "다음으로",
            isEnabled: viewStore.binding(
              get: \.isBottomButtonEnabled,
              send: { ._setIsBottomButtonEnabled($0) }
            )
          )
          .onTapGesture {
            viewStore.send(.didTapBottomButton)
          }
        }
      }
    }
  }
}

#Preview {
  SetProfileView(store: .init(initialState: .init(userRegisterModel: PND.UserRegistrationModel(email: "kevinkim@gmail.com", fbProviderType: .google, fbUid: "asdad1243", fullname: "Kevin", profileImageId: 1)), reducer: { SetProfileFeature() }))
}

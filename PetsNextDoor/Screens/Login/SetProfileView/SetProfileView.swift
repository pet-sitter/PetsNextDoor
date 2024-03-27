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
  
  @EnvironmentObject var router: Router
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        Spacer()
          .frame(height: 20)
        
        SelectProfileImageView(
          selectedImageData: viewStore.binding(
            get: \.selectedUserImageData,
            send: { .onUserProfileImageDataChange($0)}
          )
        )
        
        Spacer()
          .frame(height: 30)
         
        TextField(
          "이름",
          text: viewStore.binding(
            get: \.nicknameText,
            send: { .onNicknameTextChange($0) }
          )
        )
        .font(.system(size: 20, weight: .medium))
        .padding(8)
        .frame(height: 54)
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        .multilineTextAlignment(.leading)
        .background(.clear)
        .tint(PND.Colors.primary.asColor)
        .overlay(alignment: .trailing) {
          Text(viewStore.nicknameStatusPhrase)
            .font(.system(size: 12))
            .foregroundStyle(PND.DS.commonBlue)
            .padding(.trailing, PND.Metrics.defaultSpacing)
        }
        
        Rectangle()
          .padding(.horizontal, PND.Metrics.defaultSpacing)
          .frame(height: 1)
          .foregroundStyle(PND.Colors.gray50.asColor)
        
        Spacer().frame(height: 20)
        
        ScrollView(.vertical) {
          
          if !viewStore.petViewModels.isEmpty {
            ForEach(viewStore.petViewModels, id: \.id) { cellVM in
              SelectPetView(
                viewModel: cellVM,
                onDeleteButtonTapped: {
                  viewStore.send(.onTapPetDeleteButton(cellVM))
                }
              )
            }
          }

          Spacer().frame(height: 20)
          
          RoundedRectangle(cornerRadius: 4)
            .frame(height: 54)
            .padding(.horizontal, PND.Metrics.defaultSpacing)
            .foregroundStyle(PND.Colors.gray20.asColor)
            .contentShape(Rectangle())
            .overlay(
              Button("반려동물", systemImage: "plus") {
                viewStore.send(.onTapAddPetButton)
              }
                .foregroundStyle(.black)
            )
            .onTapGesture {
              viewStore.send(.onTapAddPetButton)
            }
          
          Spacer().frame(height: 12)
          
          Text("*반려동물을 추가하지 않으면 돌봄 관련 서비스를 이용하실 수 없습니다.")
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .foregroundStyle(UIColor(hex: "#9E9E9E").asColor)
            .font(.system(size: 12))
        }
        
        Spacer()
        
        BaseBottomButton_SwiftUI(
          title: "회원가입",
          isEnabled: viewStore.binding(
            get: \.isBottomButtonEnabled,
            send: { ._setIsBottomButtonEnabled($0) }
          )
        )
        .onTapGesture {
          viewStore.send(.onTapBottomButton)
        }
      }
    }
    .fullScreenCover(store: store
      .scope(
        state: \.$selectEitherCatOrDogState,
        action: { ._selectEitherCatOrDogAction($0)})
    ) { store in
      NavigationStack(path: $router.navigationPath) {
        SelectEitherCatOrDogView(store: store)
      }
    }
  }
}

#Preview {
  SetProfileView(store: .init(initialState: .init(userRegisterModel: PND.UserRegistrationModel(email: "kevinkim@gmail.com", fbProviderType: .google, fbUid: "asdad1243", fullname: "Kevin")), reducer: { SetProfileFeature() }))
}


import PhotosUI

struct SelectProfileImageView: View {
  
  @Binding var selectedImageData: Data?
  
  @State private var selectedImage: UIImage?
  @State private var selectedPhotoPickerItem: [PhotosPickerItem] = []
  
  var body: some View {
    ZStack {
      PhotosPicker(
        selection: $selectedPhotoPickerItem,
        maxSelectionCount: 1,
        matching: .images
      ) {
        Circle()
          .fill(PND.Colors.gray20.asColor)
          .frame(width: 100, height: 100)
          .cornerRadius(4)
          .overlay {
            if let selectedImage {
              Image(uiImage: selectedImage)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(alignment: .bottomTrailing) {
                  Circle()
                    .fill(Color.black)
                    .frame(width: 28, height: 28)
                    .overlay(
                      Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .tint(PND.Colors.primary.asColor)
                    )
                }
            } else {
              Image(systemName: "photo")
                .frame(width: 24, height: 24)
                .tint(PND.DS.commonBlack)
            }
          }
      }
    }
    .onChange(of: selectedPhotoPickerItem) { _ in
      Task { await convertImageDataToUIImage() }
    }
  }
  
  @MainActor
  private func convertImageDataToUIImage() async {
    
    selectedImage = nil
    
    if let profileImage = selectedPhotoPickerItem.first {
      
      let (uiImage, data) = await PhotoConverter.loadImageData(from: profileImage)
      guard let uiImage, let data else { return }
      
      selectedImage = uiImage
      selectedImageData = data
    }
    
  }
}

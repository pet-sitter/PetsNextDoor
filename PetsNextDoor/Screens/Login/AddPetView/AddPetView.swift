//
//  AddPetView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/26.
//

import SwiftUI
import ComposableArchitecture

struct AddPetView: View {
  
  let store: StoreOf<AddPetFeature>
  
  @EnvironmentObject var router: Router
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical) {
        VStack(spacing: 0) {
          
          Spacer()
            .frame(height: 20)
          
          SelectProfileImageView(
            selectedImageData: viewStore.binding(
              get: \.selectedPetImageData,
              send: { .onPetImageDataChange($0)}
            )
          )
          
          TextField(
            "이름",
            text: viewStore.binding(
              get: \.petName,
              send: { .onPetNameChange($0) }
            )
          )
          .font(.system(size: 20, weight: .medium))
          .padding(8)
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
          
          SelectConditionView(
            leftImageName: R.image.icon_paw.name,
            conditionTitle: viewStore.selectedPetType == .cat ? "묘종" : "견종",
            rightContentView: {
              Text(viewStore.selectedBreedName ?? (viewStore.selectedPetType == .cat ? "묘종 입력하기" : "견종 입력하기"))
                .foregroundStyle(viewStore.selectedBreedName == nil ? .gray : .commonBlack)
                .onTapGesture {
                  viewStore.send(.onSelectPetSpeciesButtonTap)
                }
            }
          )

          Spacer().frame(height: 20)
          
          SelectConditionView(
            leftImageName: R.image.icon_paw.name,
            conditionTitle: "몸무게",
            rightContentView: {
              TextField(
                "kg",
                value: viewStore.binding(
                  get: \.weight,
                  send: { .onWeightChange($0) }
                ),
                format: .number
              )
              .keyboardType(.numberPad)
              .font(.system(size: 20, weight: .medium))
              .padding(8)
              .frame(maxWidth: 70)
              .multilineTextAlignment(.trailing)
              .background(PND.Colors.gray20.asColor)
              .cornerRadius(4)
            }
          )
          
          Spacer().frame(height: 20)
          
          SelectConditionView(
            leftImageName: R.image.icon_heart.name,
            conditionTitle: "성별",
            rightContentView: {
              HStack(spacing: 8) {
                SegmentControlView_SwiftUI(
                  selectedIndex:  viewStore.binding(
                    get: \.selectedGenderIndex,
                    send: { .onPetGenderIndexChange($0) }
                  ),
                  segmentTitles: ["남자", "여자"]
                )
                CheckBoxView(isSelected: viewStore.binding(
                  get: \.isNeutralized,
                  send: { .onIsNeutralizedCheckBoxTap($0) }
                ))
                Text("중성화")
                  .font(.system(size: 20, weight: .bold))
              }

            }
          )
          
          Spacer().frame(height: 20)
          
          SelectConditionView(
            leftImageName: R.image.icon_cal.name,
            conditionTitle: "날짜",
            rightContentView: {
              DatePicker(
                selection: viewStore.binding(
                  get: \.birthdayDate,
                  send: { .onPetBirthdayDateChange($0) }
                ),
                displayedComponents: .date
              ) {}
            }
          )

          
          Spacer().frame(height: 20)
          
          SelectConditionView(
            leftImageName: R.image.icon_memo.name,
            conditionTitle: "메모",
            rightContentView: {
              
            }
          )

          Spacer().frame(height: 20)
            
          TextEditorWithBackground(
            text: viewStore.binding( 
              get: \.otherInfo,
              send: { .onOtherInfoChange($0) }
            ),
            placeholder: "반려동물에 대해 주의할 점이 있다면 메모해주세요.\nex) 닭고기 알레르기가 있어요."
          )
          .padding(.horizontal, PND.Metrics.defaultSpacing)
          .frame(height: 200)
        }
      }
        
      BaseBottomButton_SwiftUI(
        title: "추가하기",
        isEnabled: viewStore.binding(
          get: \.isBottomButtonEnabled,
          send: { .didTapBottomButton }()
        )
      )
      .onTapGesture {
        viewStore.send(.didTapBottomButton)
      }
    }
    .navigationDestination(
      store: store.scope(
        state: \.$petSpeciesListState,
        action: AddPetFeature.Action.petSpeciesListAction
      )
    ) { PetSpeciesListView(store: $0) }
  }

}

#Preview {
  AddPetView(store: .init(initialState: .init(selectedPetType: .cat), reducer: { AddPetFeature() }))
}

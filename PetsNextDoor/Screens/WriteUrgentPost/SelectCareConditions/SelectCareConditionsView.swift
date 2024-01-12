//
//  SelectCareConditionsView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI
import ComposableArchitecture

struct SelectCareConditionsView: View {
  
  let store: StoreOf<SelectCareConditionFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        Spacer().frame(height: 24)
        
        Text("돌봄 조건")
          .font(.system(size: 20, weight: .bold))
          .multilineTextAlignment(.leading)
          .padding(.leading, 20)
        
        Spacer().frame(height: 20)
        
        SelectConditionView(
          leftImageName: R.image.icon_heart.name,
          conditionTitle: "성별",
          rightContentView: {
            SegmentControlView_SwiftUI(
              selectedIndex:  viewStore.binding(
                get: \.selectedGenderIndex,
                send: { .onGenderIndexChange($0) }
              ),
              segmentTitles: ["남자만", "여자만", "상관없음"]
            )
          }
        )
        
        
        Spacer().frame(height: 20)
        
        SelectConditionView(
          leftImageName: R.image.icon_paw.name,
          conditionTitle: "돌봄형태",
          rightContentView: {
            SegmentButtonControlView(
              selectedIndex: viewStore.binding(
                get: \.selectedCareTypeIndex,
                send: { .onCareTypeIndexChange($0) }
              ),
              buttonTitles: ["방문돌봄", "위탁돌봄"]
            )
          }
        )
        
        Spacer().frame(height: 20)

        SelectConditionView(
          leftImageName: R.image.icon_cal.name,
          conditionTitle: "날짜",
          rightContentView: {
            DatePicker(
              selection: viewStore.binding(
                get: \.date,
                send: { .onDateChange($0) }
              ),
              displayedComponents: .date
            ) {}
          }
        )
        
        Spacer().frame(height: 20)
        
        SelectConditionView(
          leftImageName: R.image.icon_pay.name,
          conditionTitle: "페이",
          rightContentView: {
            
            TextField(
              "원",
              value: viewStore.binding(
                get: \.payAmount,
                send: { .onPayAmountChange($0) }
              ),
              format: .number
            )
            .keyboardType(.numberPad)
            .font(.system(size: 20, weight: .medium))
            .padding(8)
            .frame(width: 126)
            .multilineTextAlignment(.trailing)
            .background(PND.Colors.gray20.asColor)
            .cornerRadius(4)
          }
        )
        
        Spacer()
        
        BaseBottomButton_SwiftUI(
          title: "작성완료",
          isEnabled: viewStore.binding(
            get: \.isBottomButtonEnabled,
            send: { .setBottomButtonEnabled($0) }
          )
        )
        .onTapGesture {
          viewStore.send(.didTapBottomButton)
        }
      }
    }
  }
}


//#Preview {
//  SelectCareConditionsView(store: .init(initialState: .init(selectedPetIds: [1,2]), reducer: { SelectCareConditionFeature()}))
//}

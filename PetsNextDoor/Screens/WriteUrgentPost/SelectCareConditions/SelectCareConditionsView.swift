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
  
  @EnvironmentObject var router: Router
  
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
            HStack(spacing: 8) {
              Menu {
                ForEach(SelectCareConditionFeature.PayOption.allCases, id: \.self) { payOption in
                  Button {
                    Keyboard.dismiss()
                    viewStore.send(.onPayOptionChange(payOption))
                  } label: {
                    HStack {
                      Text(payOption.rawValue)
                      Spacer()
                      if viewStore.payOption == payOption {
                        Image(systemName: "checkmark")
                      }
                    }
                  }
                  
                }
              } label: {
                HStack(spacing: 4) {
                  Text(viewStore.payOption.rawValue)
                    .font(.system(size: 16))
                    .minimumScaleFactor(0.8)
                  
                  Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 12, height: 5)
                }
                .padding()
                .background(PND.DS.gray10)
                .frame(width: 100, height: 32)
                .cornerRadius(4)
                .foregroundStyle(Color.black)
              
              }
              
              TextField(
                "",
                text: viewStore.binding(
                  get: \.payAmount,
                  send: { .onPayAmountChange($0) }
                ),
                prompt: Text(viewStore.payOptionPrompt)
              )
              .keyboardType(viewStore.onlyAllowNumberInput ? .numberPad : .alphabet)
              .font(.system(size: 16, weight: .medium))
              .padding(8)
              .frame(width: 118)
              .frame(height: 32)
              .multilineTextAlignment(.trailing)
              .background(PND.DS.gray10)
              .cornerRadius(4)
              .disabled(viewStore.isPayTextFieldDisabled)
            
            }
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
          router.pushScreen(to: SelectOtherRequirementsFeature.State(urgentPostModel: viewStore.urgentPostModel))
        }
      }
      .navigationDestination(for: SelectOtherRequirementsFeature.State.self) { state in
        SelectOtherRequirementsView(store: .init(initialState: state, reducer: { SelectOtherRequirementsFeature() }))
      }
    }
  }
}


//#Preview {
//  SelectCareConditionsView(store: .init(initialState: .init(urgentPostModel: .default()), reducer: { SelectCareConditionFeature() }))
//}


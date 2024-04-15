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
          leftImageName: R.image.icon_pay.name,
          conditionTitle: "페이",
          rightContentView: {
            HStack(spacing: 8) {
              Menu {
                ForEach(PND.RewardType.allCases, id: \.self) { payOption in
                  Button {
                    Keyboard.dismiss()
                    viewStore.send(.onRewardTypeChange(payOption))
                  } label: {
                    HStack {
                      Text(payOption.text)
                      Spacer()
                      if viewStore.rewardType == payOption {
                        Image(systemName: "checkmark")
                      }
                    }
                  }
                  
                }
              } label: {
                HStack(spacing: 4) {
                  Text(viewStore.rewardType.text)
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
                  get: \.rewardAmount,
                  send: { .onRewardAmountChange($0) }
                ),
                prompt: Text(viewStore.rewardOptionPrompt)
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
        
        Spacer().frame(height: 20)
        
        SelectConditionView(
          leftImageName: R.image.icon_cal.name,
          conditionTitle: "날짜",
          rightContentView: {
            Text(viewStore.selectedDatesText)
              .font(.system(size: 16, weight: .medium))
              .padding(8)
              .frame(height: 32)
              .background(PND.DS.gray10)
              .cornerRadius(4)
          }
        )
        
        Spacer().frame(height: 20)
        
        MultiDatePicker(
          "Select a Date",
          selection: viewStore.binding(
            get: \.selectedDates,
            send: { .onSelectedDatesChanged($0) }
          ),
          in: selectableDateBounds
        )
        .tint(PND.DS.primary)
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        .padding(.bottom, 20)
        
        Spacer()
        
        BaseBottomButton_SwiftUI(
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
      .navigationDestination(
        store: store.scope(
          state: \.$selectOtherRequirementsState,
          action: { .selectOtherRequirementsAction($0) }),
        destination: { store in
          SelectOtherRequirementsView(store: store)
        }
      )
    }
  }
  
  private var selectableDateBounds: Range<Date> {
    let startDate = Date.now
    let endDate   = Calendar.current.date(byAdding: .day, value: 7, to: Date.now)!
    
    return startDate..<endDate
  }
}


//#Preview {
//  SelectCareConditionsView(store: .init(initialState: .init(urgentPostModel: .default()), reducer: { SelectCareConditionFeature() }))
//}


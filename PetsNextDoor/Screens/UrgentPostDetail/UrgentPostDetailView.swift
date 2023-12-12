//
//  UrgentPostDetailView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/11.
//

import SwiftUI
import ComposableArchitecture

struct UrgentPostDetailFeature: Reducer {
  
  struct State: Equatable {
    
    
    var detailInfoVM: [UrgentPostDetailInformationViewModel] = []
  }
  
  enum Action: Equatable {
    case onInit
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      switch action {
      case .onInit:
        state.detailInfoVM.append(contentsOf: [
          .init(title: "날짜", details: "2023.09.20 ~ 2023.09.23", isDdayVisible: true, dDayString: "D-2"),
          .init(title: "시간", details: "10:00 ~ 16:00"),
          .init(title: "위치", details: "염창동 전체"),
          .init(title: "돌봄형태", details: "위탁 돌봄"),
          .init(title: "돌봄 도우미 성별", details: "여자만"),
          .init(title: "페이", details: "시간당 10,000원")
        ])
        return .none
        
      }
    }
  }
}


struct UrgentPostDetailView: View {
  
  @State var currentType: String = "급구조건"
  
  let store: StoreOf<UrgentPostDetailFeature>
  
  struct Constants {
    static let headerViewHeight: CGFloat = 270
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          StretchyHeaderView()
          VStack {
            SwiftUI.Section {
              
              HorizontalSectionSelectView(titles: ["급구조건", "상세내용", "반려동물 프로필", "반려동물 프로필4", "반려동물 프로필2", "반려동물 프로필3"])
//                .onIndexChange { index in
//                  print("✅ index: \(index)")
//                }
              
              AgreementView()
              
              Spacer()
                .frame(height: 16)
              
              ForEach(viewStore.detailInfoVM) { vm in
                UrgentPostDetailInformationView(viewModel: vm)
                Spacer()
                  .frame(height: 15)
              }
              
            }
          }
        }
      }
      .coordinateSpace(name: "SCROLL")
      .ignoresSafeArea(.container, edges: .vertical)
      .onAppear {
        viewStore.send(.onInit)
      }
    }

  }
  

  func StretchyHeaderView() -> some View {
    GeometryReader { proxy in
      
      let minY = proxy.frame(in: .named("SCROLL")).minY
      let size = proxy.size
      let height = (size.height + minY)
      
      Image("dog_test3")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: size.width, height: height, alignment: .top)
        .overlay {
          ZStack(alignment: .bottom) {
            // For dimming out the text content
            LinearGradient(
              colors: [.clear, .black.opacity(0.5)],
              startPoint: .top,
              endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 5) {
              Text("급해요!! 푸들 한 마리 돌봐주세요.")
                .lineLimit(2)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .minimumScaleFactor(0.8)

              
              HStack(spacing: 4) {
                Circle()
                  .frame(width: 20, height: 20)
                  .overlay {
                    Image("dog_test2")
                      .resizable()
                      .scaledToFill()
                      .clipped()
                      .cornerRadius(10)
                  }
                
                Text("아롱맘")
                  .font(.system(size: 12, weight: .medium))
                  .foregroundColor(.white)
                
                Text("·")
                  .foregroundColor(.white)
                
                Text("30대 여성")
                  .font(.system(size: 12, weight: .medium))
                  .foregroundColor(.white)
                
                Text("·")
                  .foregroundColor(.white)
                
                Text("염창1동")
                  .font(.system(size: 12, weight: .medium))
                  .foregroundColor(.white)
                
              }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
        .cornerRadius(1)
        .offset(y: -minY)
    }
    .frame(height: Constants.headerViewHeight)
  }
  

  
  func AgreementView() -> some View {
    HStack(spacing: 20) {
      
      VStack(spacing: 16) {
        Image("icon_cctv")
          .frame(width: 56, height: 56)
        
        Text("펫캠촬영")
          .font(.system(size: 12, weight: .medium))
      }
      
      VStack(spacing: 16) {
        Image("icon_id")
          .frame(width: 56, height: 56)
        
        Text("신분증 인증")
          .font(.system(size: 12, weight: .medium))
      }
      
      VStack(spacing: 16) {
        Image("icon_call")
          .frame(width: 56, height: 56)
        
        Text("사전 통화")
          .font(.system(size: 12, weight: .medium))
      }
    }
    .frame(height: 115)
    .frame(maxWidth: UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2), alignment: .center)
    .background(PND.Colors.gray10.asColor)
    .cornerRadius(4)
  }
  

  
}

struct UrgentPostView_Previews: PreviewProvider {
  static var previews: some View {
    UrgentPostDetailView(store: .init(initialState: .init(), reducer: UrgentPostDetailFeature()))
  }
}



//MARK: - 돌봄급구글 상세 - 급구 조건 - 정보 뷰
struct UrgentPostDetailInformationViewModel: HashableViewModel {
  let title: String
  let details: String
  let isDdayVisible: Bool
  let dDayString: String
  
  init(
    title: String,
    details: String,
    isDdayVisible: Bool = false,
    dDayString: String = ""
  ) {
    self.title = title
    self.details = details
    self.isDdayVisible = isDdayVisible
    self.dDayString = dDayString
  }
}

struct UrgentPostDetailInformationView: View {
  
  let viewModel: UrgentPostDetailInformationViewModel
  
  var body: some View {
    HStack {
      
      Text("·")
      
      Text(viewModel.title)
        .font(.system(size: 20, weight: .medium))
      
      if viewModel.isDdayVisible {
        Text(viewModel.dDayString)
          .padding(4)
          .lineLimit(1)
          .frame(height: 22)
          .font(.system(size: 12, weight: .medium))
          .background(Color(hex: "FFDFDF"))
          .cornerRadius(4)
          .foregroundColor(.red)
      }
  
      Spacer(minLength: 10)
      
      Text(viewModel.details)
        .lineLimit(2)
        .minimumScaleFactor(0.85)
        .font(.system(size: 18, weight: .regular))
    }
    .padding(.horizontal)
  }
}


struct HorizontalSectionSelectView: View {
  
  let titles: [String]
  
  @State var currentIndex: Int = 0
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        ForEach(titles.indices, id: \.self) { index in
          
          Text(titles[index])
            .fontWeight(.bold)
            .foregroundColor(
              currentIndex == index
              ? PND.Colors.primary.asColor
              : PND.Colors.gray50.asColor
            )
            .onTapGesture {
              withAnimation(.interactiveSpring()) {
                currentIndex = index
//                onIndexChange?(currentIndex)
              }
            }
        }
      }
      .padding(.horizontal)
      .padding(.top, 24)
      .padding(.bottom, 5)
    }
  }
  
//  @Sendable private(set) var onIndexChange: ((Int) -> Void)?
  
//  mutating func onIndexChange(_ action: @escaping (Int) -> Void) -> Self {
//    self.onIndexChange = action
////    return self.body
//    return self
//  }
  
}

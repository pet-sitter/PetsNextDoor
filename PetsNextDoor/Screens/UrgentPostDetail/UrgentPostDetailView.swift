//
//  UrgentPostDetailView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/11.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct UrgentPostDetailFeature: Reducer {
  
  @Dependency(\.sosPostService) var postService
	@Dependency(\.userDataCenter) var userDataCenter
  
  @ObservableState
  struct State: Equatable, Hashable {
    let postId: String
		
		// Info
		var isMyPost: Bool = false
    
    // view related
    var selectedTabIndex: Int = 0
    var isLoading: Bool = false
    
    // header
    var title: String = ""
    var headerImageUrl: URL?
    var authorProfileImageUrl: URL?
    var authorName: String = ""
    var region: String = ""
    
    // 급구조건
    var conditions: [PND.Condition] = [] 
    var detailInfoVM: [UrgentPostDetailInformationViewModel] = []
    
    // 상세내용
    var details: String = ""
    var postImageUrls: [URL] = []
    
    // 반려동물 프로필
    var pets: [PND.Pet] = []
    var careNeededPetViewModels: [SelectPetViewModel] = []
    
    // 반려동물 상세 팝업 Overlay
    var overlayPetDetailVM: SelectPetViewModel?
    
    var isChatButtonEnabled: Bool = true
  }
  
  enum Action: RestrictiveAction, BindableAction {
  
		enum ViewAction: Equatable {
			case onInit
			case onSelectedTabIndexChange(Int)
			case onPostImageTap(index: Int)
      case onChatButtonTap
      case onPetProfileTap(petVM: SelectPetViewModel)
      case onPetDetailOverlayCloseButtonTap
		}
		
		enum DelegateAction: Equatable {
			
		}
		
    enum InternalAction: Equatable {
			case setIsLoading(Bool)
      case setHeaderInfo(PND.SOSPostDetailModel)
      case setConditionInfo(PND.SOSPostDetailModel)
      case setDetailInfo(String, [PND.MediaModel])
      case setPetProfileInfo([PND.Pet])
      case setChatButtonEnabled(Bool)
			case setIsMyPost(Bool)
		}
		
		case view(ViewAction)
		case delegate(DelegateAction)
		case `internal`(InternalAction)
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State,Action> {
    BindingReducer()
    Reduce { state, action in
      
      switch action {
			case .view(.onInit):
        return .run { [postId = state.postId] send in
       
					await send(.internal(.setIsLoading(true)))
					
					try await Task.sleep(nanoseconds: 500_000_000)
          
//          let postDetail = try await postService.getSOSPostDetail(id: postId)
//					
//          await send(.internal(.setHeaderInfo(postDetail)))
//          await send(.internal(.setConditionInfo(postDetail)))
//          await send(.internal(.setDetailInfo(postDetail.content, postDetail.media)))
//          await send(.internal(.setPetProfileInfo(postDetail.pets)))
					
//					await send(.internal(.setIsLoading(false)))
//					
//					let myId = await userDataCenter.userProfileModel?.id
//					await send(.internal(.setIsMyPost(myId == postDetail.author?.id ? true : false )))
					
        } catch: { error, send in
          print("❌ error: \(error)")
          Toast.shared.presentCommonError()
        }
				
			case .view(.onSelectedTabIndexChange(let index)):
				state.selectedTabIndex = index
				return .none
				
			case .view(.onPostImageTap(let index)):
        // ImageViewer 같은거 간단하게 만들어야할듯?
				return .none
        
      case .view(.onChatButtonTap):
        
        return .none
        
      case .view(.onPetProfileTap(let petVM)):
        state.overlayPetDetailVM = petVM
        return .none
        
      case .view(.onPetDetailOverlayCloseButtonTap):
        state.overlayPetDetailVM = nil
        return .none
        
      case .internal(.setChatButtonEnabled(let isEnabled)):
        state.isChatButtonEnabled = isEnabled
        return .none
				
			case .internal(.setIsMyPost(let isMyPost)):
				state.isMyPost = isMyPost
				return .none
        
      case .internal(.setHeaderInfo(let postDetailModel)):
        state.title = postDetailModel.title
        
        if let image = postDetailModel.media.first {
          state.headerImageUrl = URL(string: image.url)
        }
        
        if let authorProfileImageUrl = postDetailModel.author?.profileImageUrl {
          state.authorProfileImageUrl = URL(string: authorProfileImageUrl)
        }
        
        if let authorName = postDetailModel.author?.nickname {
          state.authorName = authorName
        }
        
        state.region = "N/A"
        
        return .none
				
        // 급구 조건
			case .internal(.setConditionInfo(let postDetailModel)):
        
        let dDay: Int?              = DateConverter.calculateDDay(using: postDetailModel.dates.first?.dateStartAt)
        let dDayString: String      = "D-\(dDay ?? 0)"
        let isDDayTagVisible: Bool  = (dDay ?? 1000) <= 7 && dDay != 0
        
        let payDetailString: String = "\(postDetailModel.rewardType?.text ?? PND.RewardType.negotiable.text) " + "\(NumberConverter.convertToCurrency(postDetailModel.reward ?? ""))"
         
				state.detailInfoVM.append(contentsOf: [
          .init(title: "날짜", details: convertDateToString(postDetailModel.dates), isDdayVisible: isDDayTagVisible, dDayString: dDayString),
					.init(title: "위치", details: "N/A"),
          .init(title: "돌봄형태", details: postDetailModel.careType.description),
          .init(title: "돌봄 도우미 성별", details: postDetailModel.carerGender.description),
          .init(title: "페이", details: payDetailString)
				])
				return .none
				
        // 상세 내용
			case .internal(.setDetailInfo(let content, let mediaModel)):
        
        state.details = content
        state.postImageUrls = mediaModel
          .map        { $0.url }
          .compactMap { URL(string: $0) }
        
				return .none
        
        // 반려동물 프로필
      case .internal(.setPetProfileInfo(let pets)):
        state.pets = pets
        state.careNeededPetViewModels = pets.map { pet -> SelectPetViewModel in
          SelectPetViewModel(
            petImageUrlString: pet.profileImageUrl,
            petName: pet.name,
            petSpecies: pet.breed,
            petAge: 1,
            isPetNeutralized: pet.neutered,
            isPetSelected: false,
            gender: pet.sex,
            petType: pet.petType,
            birthday: pet.birthDate,
            isDeleteButtonHidden: true
          )
        }
        return .none
				
			case .internal(.setIsLoading(let isLoading)):
				state.isLoading = isLoading
				return .none
        

      case .binding:
        return .none
      }
    }
  }
  
  private func convertDateToString(_ dates: [PND.Date]) -> String {
    guard
      let startingDate = dates.first?.dateStartAt,
      let endingDate   = dates.last?.dateEndAt
    else { return "N/A" }
    
    if startingDate == endingDate { return startingDate }
    
    return "\(startingDate) ~ \(endingDate.dropFirst(5))"
  }
}


import Kingfisher

struct UrgentPostDetailView: View {
  
  @State var store: StoreOf<UrgentPostDetailFeature>

  @State var pageIndex: Int = 0
  
  struct Constants {
    static let headerViewHeight: CGFloat = 270
  }
  
  var body: some View {
    VStack {
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          
          StretchyHeaderView(
            headerImageUrl: store.headerImageUrl,
            title: store.title,
            authorName: store.authorName,
            authorProfileImageUrl: store.authorProfileImageUrl,
            region: store.region
          )
          
          VStack {
            SwiftUI.Section {
              
              HorizontalSectionSelectView(
                titles: ["급구조건", "상세내용", "반려동물 프로필"],
                currentIndex: $store.selectedTabIndex
              )
              
              switch store.selectedTabIndex {
                
              case 0:
                AgreementView(conditions: store.conditions)
                
                Spacer()
                  .frame(height: 16)
                
                ForEach(store.detailInfoVM) { vm in
                  UrgentPostDetailInformationView(viewModel: vm)
                  Spacer()
                    .frame(height: 15)
                }
                
              case 1:
                VStack(alignment: .leading, spacing: 25) {
                  
                  Text(store.details)
                    .font(.system(size: 16))
                    .lineSpacing(5)
                    .multilineTextAlignment(.leading)
                  
                  
                  ScrollView(.horizontal) {
                    
                    HStack(spacing: 3) {
                      ForEach(
                        0..<(min(store.postImageUrls.count, 3)),
                        id: \.self
                      ) { index in
                        
                        KFImage(store.postImageUrls[index])
                          .placeholder {
                            ProgressView()
                          }
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: 112, height: 112)
                          .clipped()
                          .cornerRadius(4)
                          .overlay {
                            ZStack {
                              Rectangle()
                                .foregroundColor(.clear)
                                .background(.black.opacity(0.5))
                                .cornerRadius(4)
                              
                              Text("+\(store.postImageUrls.count - 3)")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                            }
                            .opacity((store.postImageUrls.count > 3 && index == 2) ? 1 : 0)
                          }
                          .onTapGesture {
                            store.send(.view(.onPostImageTap(index: index)))
                          }
                      }
                    }
                  }
                }
                .padding(.top, 16)
                .padding(.horizontal, PND.Metrics.defaultSpacing)
                
              case 2:
                VStack(alignment: .center) {
                  
                  Text("돌봄이 필요한 반려동물")
                    .font(.system(size: 16, weight: .semibold))
                    .modifier(TextLeadingModifier())
                    .padding(.leading, 16)
                  
                  Spacer().frame(height: 9)
                  
                  if store.pets.isEmpty {
                    Spacer().frame(height: 30)
                    Text("반려동물 등록 정보가 없습니다.")
                  } else {
                    
                    TabView(selection: $pageIndex.animation()) {
                      ForEach(0..<store.careNeededPetViewModels.count, id: \.self) { index in
                        
                        SelectPetView(
                          viewModel: store.careNeededPetViewModels[index],
                          onDeleteButtonTapped: nil
                        )
                        .tag(index)
                        .onTapGesture {
                          store.send(.view(.onPetProfileTap(petVM: store.careNeededPetViewModels[index])))
                        }
                        
                      }
                      .frame(height: 100)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 120)
                    .overlay(
                      alignment: .bottom,
                      content: {
                        PageControl(
                          numberOfPages: store.pets.count,
                          currentIndex: $pageIndex
                        )
                        .offset(y: 10)
                      }
                    )
                    
                    Spacer().frame(height: 20)
                    
                    Text("\(store.authorName)의 반려동물")
                      .font(.system(size: 16, weight: .semibold))
                      .modifier(TextLeadingModifier())
                      .padding(.leading, 16)
                    
                    Spacer().frame(height: 8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                      HStack(spacing: 0) {
                        
                        // 이 부분 수정 필요 - 전체 반려동물 목록
                        ForEach(store.pets, id: \.id) { pet in
                          PetProfileView(pet)
                        }
                        
                        Spacer()
                      }
                      .padding(.leading, 12)
                      .frame(width: UIScreen.main.bounds.size.width)
                      .frame(minHeight: 150)
                    }
                    .frame(maxWidth: 400)
                  }
                }
                .padding(.top, 12)
                
              default:
                SwiftUI.EmptyView()
              }
            }
          }
        }
      }
      .redacted(reason: store.isLoading ? .placeholder : [])
      .coordinateSpace(name: "SCROLL")
      .ignoresSafeArea(.container, edges: .vertical)
      .onAppear {
        store.send(.view(.onInit))
      }
      
      BaseBottomButton_SwiftUI(
        isEnabledColor: PND.DS.primary,
        title: "채팅하기",
        isEnabled: $store.isChatButtonEnabled
      )
      .onTapGesture { store.send(.view(.onChatButtonTap)) }
    }
    .overlay(store.overlayPetDetailVM == nil ? nil : PetDetailOverlayView(petVM: store.overlayPetDetailVM!))
    
    .animation(.default, value: store.overlayPetDetailVM)
  }
  
  func PetDetailOverlayView(petVM: SelectPetViewModel) -> some View {
    ZStack {
      Color
        .black
        .opacity(0.5)
      
      VStack(spacing: 0) {
        
        Spacer().frame(height: 17)
        
        HStack {
          Spacer()
          Button {
            store.send(.view(.onPetDetailOverlayCloseButtonTap))
          } label: {
            Image(systemName: "xmark")
              .frame(width: 24, height: 24)
              .foregroundStyle(PND.DS.commonBlack)
          }
          Spacer().frame(width: 16)
        }
        
        
        CircularProfileImageView(imageUrlString: petVM.petImageUrlString ?? "")
        
        Spacer().frame(height: 3)
        
        HStack(spacing: 0) {
          
          Text(petVM.petName)
            .font(.system(size: 16, weight: .bold))
          
          Image(petVM.gender == .male ? "male_icon" : "female_icon")
            .resizable()
            .frame(width: 20, height: 20)
            .scaledToFit()
        }
        
        Spacer().frame(height: 3)
        
        Text(petVM.isPetNeutralized ? "중성화 O" : "중성화 X")
          .padding(4)
          .lineLimit(1)
          .frame(height: 22)
          .background(PND.Colors.lightGreen.asColor)
          .cornerRadius(4)
          .foregroundColor(PND.Colors.primary.asColor)
          .font(.system(size: 12, weight: .bold))
        
        Spacer().frame(height: 12)
        
        
        // 생일, 몸무게, 견종
        Group {
          HStack(spacing: 12) {
            
            HStack(spacing: 4) {
              Circle()
                .foregroundStyle(PND.DS.primary)
                .frame(width: 4, height: 4)
              
              Text("생일")
                .font(.system(size: 12, weight: .bold))
              
              Text(petVM.birthday)
                .font(.system(size: 12, weight: .regular))
                .minimumScaleFactor(0.85)
                .lineLimit(1)
            }
            
            HStack(spacing: 4) {
              Circle()
                .foregroundStyle(PND.DS.primary)
                .frame(width: 4, height: 4)
              
              Text("몸무게")
                .font(.system(size: 12, weight: .bold))
              
              Text((petVM.weight ?? "N/A") + "kg")
                .font(.system(size: 12, weight: .regular))
                .minimumScaleFactor(0.85)
                .lineLimit(1)
            }
            
            HStack(spacing: 4) {
              Circle()
                .foregroundStyle(PND.DS.primary)
                .frame(width: 4, height: 4)
              
              Text("견종")
                .font(.system(size: 12, weight: .bold))
              
              Text(petVM.petSpecies)
                .font(.system(size: 12, weight: .regular))
                .minimumScaleFactor(0.85)
                .lineLimit(1)
            }
          }
        }
        .padding(.horizontal, 32)
        
        
        // Separator
        Group {
          Spacer().frame(height: 12)
          Rectangle()
            .foregroundStyle(PND.DS.gray20)
            .frame(height: 1)
            .padding(.horizontal, 29)
          Spacer().frame(height: 8)
        }

        
        // 건강관련 주의사항
        Group {
          HStack(spacing: 4) {
            Circle()
              .foregroundStyle(PND.DS.primary)
              .frame(width: 4, height: 4)
            
            Text("건강관련 주의사항")
              .font(.system(size: 12, weight: .bold))
            
            Spacer()
          }

          Spacer().frame(height: 8)
          
          Text("특별한 주의사항은 없지만 관절이 좋지 않아서 높은 곳에서 점프 못하게 해주세요. 알러지가 조금 심해서 눈물을 자주 닦아줘야하고 펫우유는 못먹어요.")
            .font(.system(size: 12, weight: .regular))
          
        }
        .padding(.horizontal, 32)
        
        // Separator
        Group {
          Spacer().frame(height: 12)
          Rectangle()
            .foregroundStyle(PND.DS.gray20)
            .frame(height: 1)
            .padding(.horizontal, 29)
          Spacer().frame(height: 8)
        }
        
        // 돌봄시 참고사항
        Group {
          HStack(spacing: 4) {
            Circle()
              .foregroundStyle(PND.DS.primary)
              .frame(width: 4, height: 4)
            
            Text("돌봄시 참고사항")
              .font(.system(size: 12, weight: .bold))
            
            Spacer()
          }
          
          Spacer().frame(height: 8)
          
          
          Text(petVM.remarks ?? "N/A")
            .font(.system(size: 12, weight: .regular))
          
        }
        .padding(.horizontal, 32)
        
        
        // Separator
        Group {
          Spacer().frame(height: 12)
          Rectangle()
            .foregroundStyle(PND.DS.gray20)
            .frame(height: 1)
            .padding(.horizontal, 29)
          Spacer().frame(height: 8)
        }
        
        
        
        
        
        Spacer()
        
        
      }
      .frame(
        width: UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2),
        height: (UIScreen.fixedScreenSize.height / 6) * 3.7
      )
      .background(PND.DS.commonWhite)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      
      
    }
    .ignoresSafeArea(.all)
  }

  func StretchyHeaderView(
    headerImageUrl: URL?,
    title: String,
    authorName: String,
    authorProfileImageUrl: URL?,
    region: String
  ) -> some View {
    GeometryReader { proxy in
      
      let minY 		= proxy.frame(in: .named("SCROLL")).minY
      let size 		= proxy.size
      let height 	= size.height + minY
      
      KFImage(headerImageUrl)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: size.width, height: height, alignment: .top)
        .overlay {
          ZStack(alignment: .bottom) {
            LinearGradient(
              colors: [.clear, .black.opacity(0.5)],
              startPoint: .top,
              endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 5) {
              Text(title)
                .lineLimit(2)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .minimumScaleFactor(0.8)

              
              HStack(spacing: 4) {
                Circle()
                  .frame(width: 20, height: 20)
                  .overlay {
                    KFImage(authorProfileImageUrl)
                      .placeholder { ProgressView() }
                      .scaledToFill()
                      .clipped()
                      .cornerRadius(10)
                  }
                
                Text(authorName)
                  .font(.system(size: 12, weight: .medium))
                  .foregroundColor(.white)
                
                if !region.isEmpty {
                  Text("·")
                    .foregroundColor(.white)
                  
                  Text(region)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                }
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
  
  func AgreementView(conditions: [PND.Condition]) -> some View {
    HStack(spacing: 20) {
    

//      let isFirstSelected = conditions.first(where: { $0.id == 1 }) != nil
//      let isSecondSelected = conditions.first(where: { $0.id == 2 }) != nil
//      let isThirdSelected = conditions.first(where: { $0.id == 3 }) != nil
      
//      VStack(spacing: 16) {        
//        Image(isFirstSelected ? "icon_cctv_on" : "icon_cctv_off")
//          .frame(width: 56, height: 56)
//        
//        Text("펫캠촬영")
//          .font(.system(size: 12, weight: .medium))
//      }
//      
//      VStack(spacing: 16) {
//        Image(isSecondSelected ? "icon_id_on" : "icon_id_off")
//          .frame(width: 56, height: 56)
//        
//        Text("신분증 인증")
//          .font(.system(size: 12, weight: .medium))
//      }
//      
//      VStack(spacing: 16) {
//        Image(isThirdSelected ? "icon_call_on" : "icon_call_off")
//          .frame(width: 56, height: 56)
//        
//        Text("사전 통화")
//          .font(.system(size: 12, weight: .medium))
//      }
    }
    .frame(height: 115)
    .frame(maxWidth: UIScreen.fixedScreenSize.width - (PND.Metrics.defaultSpacing * 2), alignment: .center)
    .background(PND.Colors.gray10.asColor)
    .cornerRadius(4)
  }
  
  func PetProfileView(_ petModel: PND.Pet) -> some View {
    VStack(spacing: 0) {
      
      KFImage(petModel.profileImageUrl?.asURL())
        .resizable()
        .frame(width: 48, height: 48)
        .clipShape(Circle())
        .scaledToFill()
      
      Spacer().frame(height: 8)
      
      HStack(spacing: 0) {
        Text(petModel.name)
          .font(.system(size: 12, weight: .bold))
          .multilineTextAlignment(.center)
        
        Image(petModel.sex == .male ? "male_icon" : "female_icon")
          .resizable()
          .frame(width: 15, height: 15)
          .scaledToFit()
      }
      
      Spacer().frame(height: 4)
      
      Text(petModel.breed)
        .font(.system(size: 12, weight: .regular))
        .minimumScaleFactor(0.75)
        .multilineTextAlignment(.center)
      
    }
    .padding()
    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(PND.DS.gray30, lineWidth: 1)
      
    )
    .frame(width: 100, height: 140)
  }
}

#Preview {
  UrgentPostDetailView(store: .init(initialState: .init(postId: "3"), reducer: { UrgentPostDetailFeature() }))
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
  @Binding var currentIndex: Int
  
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

              }
            }
        }
      }
      .padding(.horizontal)
      .padding(.top, 24)
      .padding(.bottom, 5)
    }
  }
}

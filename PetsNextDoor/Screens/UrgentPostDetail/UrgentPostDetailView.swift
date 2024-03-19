//
//  UrgentPostDetailView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/11.
//

import SwiftUI
import ComposableArchitecture

struct UrgentPostDetailFeature: Reducer {
  
  @Dependency(\.sosPostService) var postService
  
  struct State: Equatable, Hashable {
    let postId: Int
    
    // view related
    var selectedTabIndex: Int = 2
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
  }
  
  enum Action: Equatable, RestrictiveAction {
  
		enum ViewAction: Equatable {
			case onInit
			case onSelectedTabIndexChange(Int)
			case onPostImageTap(index: Int)
		}
		
		enum DelegateAction: Equatable {
			
		}
		
    enum InternalAction: Equatable {
			case setIsLoading(Bool)
      case setHeaderInfo(PND.SOSPostDetailModel)
      case setConditionInfo(PND.SOSPostDetailModel)
      case setDetailInfo(String, [PND.MediaModel])
      case setPetProfileInfo([PND.Pet])
		}
		
		case view(ViewAction)
		case delegate(DelegateAction)
		case `internal`(InternalAction)
  }
  
  var body: some Reducer<State,Action> {
    Reduce { state, action in
      
      switch action {
			case .view(.onInit):
        return .run { [postId = state.postId] send in
       
					await send(.internal(.setIsLoading(true)))
					
					try await Task.sleep(nanoseconds: 500_000_000)
          
          let postDetail = try await postService.getSOSPostDetail(id: postId)
    
          
          await send(.internal(.setHeaderInfo(postDetail)))
          await send(.internal(.setConditionInfo(postDetail)))
          await send(.internal(.setDetailInfo(postDetail.content, postDetail.media)))
//          await send(.internal(.setPetProfileInfo(postDetail.pets)))
          await send(.internal(.setPetProfileInfo([PND.Pet(id: 1, name: "다롱이", petType: .cat, sex: .female, neutered: false, breed: "푸들", birth_date: "123", weightInKg: 2), PND.Pet(id: 1, name: "다롱이", petType: .cat, sex: .female, neutered: false, breed: "푸들", birth_date: "123", weightInKg: 2), PND.Pet(id: 1, name: "다롱이", petType: .cat, sex: .female, neutered: false, breed: "푸들", birth_date: "123", weightInKg: 2)])))
          
			
          
					await send(.internal(.setIsLoading(false)))
          
        } catch: { error, send in
          print("❌ error")
        }
				
			case .view(.onSelectedTabIndexChange(let index)):
				state.selectedTabIndex = index
				return .none
				
			case .view(.onPostImageTap(let index)):
        // ImageViewer 같은거 간단하게 만들어야할듯?
				return .none
        
        
      case .internal(.setHeaderInfo(let postDetailModel)):
        state.title = postDetailModel.title
        
        if let image = postDetailModel.media.first {
          state.headerImageUrl = URL(string: image.url)
        }
        
        if let authorProfileImageUrl = postDetailModel.author.profileImageUrl {
          state.authorProfileImageUrl = URL(string: authorProfileImageUrl)
        }
        
        
        state.authorName = postDetailModel.author.nickname
        state.region = "화곡동"
        
        return .none
				
        // 급구 조건
			case .internal(.setConditionInfo(let postDetailModel)):
				state.detailInfoVM.append(contentsOf: [
					.init(title: "날짜", details: "2023.09.20 ~ 2023.09.23", isDdayVisible: true, dDayString: "D-2"),
					.init(title: "위치", details: "N/A"),
          .init(title: "돌봄형태", details: postDetailModel.careType.description),
          .init(title: "돌봄 도우미 성별", details: postDetailModel.carerGender.description),
					.init(title: "페이", details: "시간당 10,000원")
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
            petImageUrlString: MockDataProvider.randomPetImageUrlString,
            petName: pet.name,
            petSpecies: pet.breed,
            petAge: 1,
            isPetNeutralized: pet.neutered,
            isPetSelected: false,
            gender: pet.sex,
            petType: pet.petType,
            birthday: pet.birth_date,
            isDeleteButtonHidden: true
          )
        }
        return .none
				
			case .internal(.setIsLoading(let isLoading)):
				state.isLoading = isLoading
				return .none

      }
    }
  }
}


import Kingfisher

struct UrgentPostDetailView: View {
  
  let store: StoreOf<UrgentPostDetailFeature>
  
  @State var pageIndex: Int = 0
  
  struct Constants {
    static let headerViewHeight: CGFloat = 270
  }
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          
          StretchyHeaderView(
            headerImageUrl: viewStore.authorProfileImageUrl,
            title: viewStore.title,
            authorName: viewStore.authorName,
            authorProfileImageUrl: viewStore.authorProfileImageUrl,
            region: viewStore.region
          )
          
          VStack {
            SwiftUI.Section {
							
							HorizontalSectionSelectView(
								titles: ["급구조건", "상세내용", "반려동물 프로필"],
								currentIndex: viewStore.binding(
									get: \.selectedTabIndex,
									send: { .view(.onSelectedTabIndexChange($0)) }
								)
							)

							switch viewStore.selectedTabIndex {
							
							case 0:
                AgreementView(conditions: viewStore.conditions)
								
								Spacer()
									.frame(height: 16)
								
								ForEach(viewStore.detailInfoVM) { vm in
									UrgentPostDetailInformationView(viewModel: vm)
									Spacer()
										.frame(height: 15)
								}
								
							case 1:
                VStack(alignment: .leading, spacing: 25) {
									
									Text(viewStore.details)
										.font(.system(size: 16))
										.lineSpacing(5)
                    .multilineTextAlignment(.leading)
                    
									
									ScrollView(.horizontal) {
				
										HStack(spacing: 3) {
                      ForEach(
                        0..<(min(viewStore.postImageUrls.count, 3)),
                        id: \.self
                      ) { index in
                        
                        KFImage(viewStore.postImageUrls[index])
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
                              
                              Text("+\(viewStore.postImageUrls.count - 3)")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                            }
                            .opacity((viewStore.postImageUrls.count > 3 && index == 2) ? 1 : 0)
                          }
                          .onTapGesture {
                            viewStore.send(.view(.onPostImageTap(index: index)))
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
                  
                  if viewStore.pets.isEmpty {
                    Spacer().frame(height: 30)
                    Text("반려동물 등록 정보가 없습니다.")
                  } else {
                    
                    TabView(selection: $pageIndex.animation()) {
                      ForEach(0..<viewStore.pets.count, id: \.self) { index in
                        SelectPetView(
                          viewModel: viewStore.careNeededPetViewModels.first!,
                          onDeleteButtonTapped: nil
                        )
                        .tag(index)
                      }
                      .frame(height: 100)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 120)
                    .overlay(
                      alignment: .bottom,
                      content: {
                        PageControl(
                          numberOfPages: viewStore.pets.count,
                          currentIndex: $pageIndex
                        )
                        .offset(y: 10)
                      }
                    )
                    
                    Spacer().frame(height: 20)
                    
                    Text("\(viewStore.authorName)의 반려동물")
                      .font(.system(size: 16, weight: .semibold))
                      .modifier(TextLeadingModifier())
                      .padding(.leading, 16)
                    
                    Spacer().frame(height: 8)

                    ScrollView(.horizontal, showsIndicators: false) {
                      HStack(spacing: 0) {
                        
                        ForEach(viewStore.pets, id: \.id) { pet in
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
			.redacted(reason: viewStore.isLoading ? .placeholder : [])
      .coordinateSpace(name: "SCROLL")
      .ignoresSafeArea(.container, edges: .vertical)
      .onAppear {
				viewStore.send(.view(.onInit))
      }
    }

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
                    AsyncImage(url: authorProfileImageUrl) { image in
                      image.resizable()
                    } placeholder: {
                      ProgressView()
                    }
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
      

      
      let isFirstSelected = conditions.first(where: { $0.id == 1 }) != nil
      let isSecondSelected = conditions.first(where: { $0.id == 2 }) != nil
      let isThirdSelected = conditions.first(where: { $0.id == 3 }) != nil
      
      VStack(spacing: 16) {        
        Image(isFirstSelected ? "icon_cctv_on" : "icon_cctv_off")
          .frame(width: 56, height: 56)
        
        Text("펫캠촬영")
          .font(.system(size: 12, weight: .medium))
      }
      
      VStack(spacing: 16) {
        Image(isSecondSelected ? "icon_id_on" : "icon_id_off")
          .frame(width: 56, height: 56)
        
        Text("신분증 인증")
          .font(.system(size: 12, weight: .medium))
      }
      
      VStack(spacing: 16) {
        Image(isThirdSelected ? "icon_call_on" : "icon_call_off")
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
  
  func PetProfileView(_ petModel: PND.Pet) -> some View {
    VStack(spacing: 0) {
      
      KFImage(MockDataProvider.randomePetImageUrl)
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
        .stroke(Color.gray30, lineWidth: 1)
      
    )
    .frame(width: 100, height: 140)
  }
}

#Preview {
  UrgentPostDetailView(store: .init(initialState: .init(postId: 24), reducer: { UrgentPostDetailFeature() }))
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

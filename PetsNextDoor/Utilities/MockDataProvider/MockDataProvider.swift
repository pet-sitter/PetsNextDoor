//
//  MockDataProvider.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation

struct MockDataProvider {
  
  static var randomAuthorName: String {
    [
      "아롱맘",
      "다롱이맘",
      "시바견 주인",
      "케빈킴",
      "Boris"
    ]
      .randomElement()!
  }
  
  static var randomCount: Int {
    [1, 32, 120, 4, 6, 21, 64, 2, 3, 100, 49].randomElement()!
  }
  
  static var randomChatMessage: String {
    [
      "오늘 말고 내일 오셔도 되는데 가능할까요??",
      "주의사항 알려드려요~ 밥은 하루에 3끼, 8시 12시 6시 이렇게 주시면 돼요",
      "강아지가 산책하는걸 엄청 좋아해요 ㅜㅜ",
      "고양이가 사람을 엄청 좋아하고 완전 개냥이입니다!!",
      "네!",
      "네네 다음 주 월요일 시작입니다! 괜찮을까요?",
      "좋아요~",
    ]
      .randomElement()!
  }
  
  static var randomPetImageUrlString: String {
    "https://placedog.net/200/200?random"
  }
  
  static var randomePetImageUrl: URL {
    URL(string: "https://placedog.net/200/200?random")!
  }
  
  static var selectPetCellViewModels: [SelectPetViewModel] {
    [
      .init(
        petImageUrlString: "https://placedog.net/200/200random",
        petName: "아롱이",
        petSpecies: "비숑 프리제",
        petAge: 1,
        isPetNeutralized: false,
        isPetSelected: false,
        gender: .male,
        petType: .dog,
        birthday: "12/23",
        weight: 1,
        isDeleteButtonHidden: true
      ),
      .init(
        petImageUrlString: "https://placedog.net/200/200?random",
        petName: "아롱이",
        petSpecies: "비숑 프리제",
        petAge: 1,
        isPetNeutralized: false,
        isPetSelected: false,
        gender: .male,
        petType: .dog,
        birthday: "12/23",
        weight: 1,
        isDeleteButtonHidden: true
      ),
      .init(
        petImageUrlString: "https://placedog.net/200/200?random",
        petName: "아롱이",
        petSpecies: "비숑 프리제",
        petAge: 1,
        isPetNeutralized: false,
        isPetSelected: false,
        gender: .male,
        petType: .dog,
        birthday: "12/23",
        weight: 1,
        isDeleteButtonHidden: true
      ),
      .init(
        petImageUrlString: "https://placedog.net/200/200?random",
        petName: "아롱이",
        petSpecies: "비숑 프리제",
        petAge: 1,
        isPetNeutralized: false,
        isPetSelected: false,
        gender: .male,
        petType: .dog,
        birthday: "12/23",
        weight: 1,
        isDeleteButtonHidden: true
      ),
      
    ]
  }
}

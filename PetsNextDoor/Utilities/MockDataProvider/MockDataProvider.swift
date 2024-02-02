//
//  MockDataProvider.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation

struct MockDataProvider {
  
  static var randomPetImageUrlString: String {
    "https://placedog.net/200/200?random"
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

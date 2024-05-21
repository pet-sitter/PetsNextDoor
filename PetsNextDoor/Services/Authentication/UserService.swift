//
//  UserService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation

protocol UserServiceProvidable: PNDNetworkProvidable {
  
  func checkNicknameDuplication(_ nickname: String) async throws -> PND.CheckNicknameModel
  func getMyPets() async throws -> PND.MyPetListModel
  func registerMyPets(_ pets: [PND.Pet]) async throws
  func getMyProfileInfo() async throws -> PND.UserProfileModel
  func getUserInfo(userId: Int) async throws -> PND.UserInfoModel
}

final class UserService: UserServiceProvidable {

  typealias Network = PND.Network<PND.API>
  
  private(set) var network: Network = .init()
  private let uploadService = MediaService()
  
  func checkNicknameDuplication(_ nickname: String) async throws -> PND.CheckNicknameModel {
    try await network.requestData(.postCheckNickname(nickname: nickname))
  }
  
  func getMyPets() async throws -> PND.MyPetListModel {
    try await network.requestData(.getMyPets)
  }
  
  func registerMyPets(_ pets: [PND.Pet]) async throws {
    try await network.plainRequest(.putMyPets(model: pets))
  }
  
  func getMyProfileInfo() async throws -> PND.UserProfileModel {
    try await network.requestData(.getMyProfile)
  }
  
  func getUserInfo(userId: Int) async throws -> PND.UserInfoModel {
    try await network.requestData(.getUserInfo(userId: userId))
  }
}



final class UserServiceMock: UserServiceProvidable {
  
  typealias Network = PND.MockNetwork<PND.API>
  
  private(set) var network: Network = .init()
  
  func checkNicknameDuplication(_ nickname: String) async throws -> PND.CheckNicknameModel {
    return .init(isAvailable: true)
  }
  
  func getMyPets() async throws -> PND.MyPetListModel {
    return .init(pets: [
      PND.Pet(
        id: 1,
        name: "pet test 1",
        petType: .cat,
        sex: .female,
        neutered: true,
        breed: "먼치킨",
        birthDate: "2022-10-20",
        weightInKg: "6",
        remarks: "주의사항 테스트입니다 1"
      ),
      PND.Pet(
        id: 2,
        name: "pet test 2",
        petType: .dog,
        sex: .male,
        neutered: false,
        breed: "숏헤어",
        birthDate: "2020-12-12",
        weightInKg: "6",
        remarks: "주의사항 테스트입니다 2"
      ),
    ])
  }
  
  func registerMyPets(_ pets: [PND.Pet]) async throws {
    ()
  }
  
  func getMyProfileInfo() async throws -> PND.UserProfileModel {
    return .init(
      id: 1,
      email: "test@gmail.com",
      fbProviderType: .google,
      fullname: "Test Fullname",
      nickname: "Test Nickname",
      profileImageUrl: MockDataProvider.randomPetImageUrlString
    )
  }
  
  func getUserInfo(userId: Int) async throws -> PND.UserInfoModel {
    return .init(
      id: 1,
      nickname: "test userInfo",
      profileImageUrl: MockDataProvider.randomPetImageUrlString,
      pets: []
    )
  }
}

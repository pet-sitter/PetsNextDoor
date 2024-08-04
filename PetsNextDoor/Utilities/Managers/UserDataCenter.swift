//
//  UserDataCenter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/01.
//

import Foundation

@MainActor
final class UserDataCenter {
  
  static let shared: UserDataCenter = .init()
	
	private let petService: any PetServiceProvidable 	 = PetService()
	private let userService: any UserServiceProvidable = UserService()
	
	private(set) var userProfileModel: PND.UserProfileModel?
  private(set) var hasPetsRegistered: Bool = false
	
	func configureInitialUserData() {
		Task {
			let _ = [
				await checkIfUserHasPetsRegistered(),
				await fetchCurrentUserProfileModel()
			]
		}
	}
	
	private func checkIfUserHasPetsRegistered() async {
		do {
			let myPets = try await petService.getMyPets().pets
			
			self.hasPetsRegistered = myPets.isEmpty ? false : true
			
		} catch {
			PNDLogger.network.error("UserDataCenter : failed checkIfUserHasPetsRegistered : \(error)")
		}
	}
	
	private func fetchCurrentUserProfileModel() async {
		do {
			let userModel = try await userService.getMyProfileInfo()
			
			self.userProfileModel = userModel
			
		} catch {
			PNDLogger.network.error("UserDataCenter : failed fetchCurrentUserProfileModel : \(error)")
		}
	}
}



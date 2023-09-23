//
//  UploadService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/23.
//

import Foundation

protocol UploadServiceProvidable: PNDNetworkProvidable {
  func uploadImage(imageData: Data, imageName: String) async throws -> PND.UploadMediaResponseData
}

final class UploadService: UploadServiceProvidable {
  
  typealias Network = PND.Network<PND.API>
  
  private(set) var network: Network = .init()
  
  func uploadImage(imageData: Data, imageName: String) async throws -> PND.UploadMediaResponseData {
    do {
      return try await network.requestData(.uploadImage(imageData: imageData, imageName: imageName))
    } catch {
      throw PND.ServiceError.uploadImageFailed
    }
  }
}


final class UploadServiceMock: UploadServiceProvidable {
  
  typealias Network = PND.Network<PND.API>
  
  private(set) var network: Network = .init()
  
  func uploadImage(imageData: Data, imageName: String) async throws -> PND.UploadMediaResponseData {
    throw PND.ServiceError.uploadImageFailed
  }
}

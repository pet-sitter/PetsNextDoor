//
//  MediaService.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/23.
//

import Foundation

protocol MediaServiceProvidable: PNDNetworkProvidable {
  func uploadImage(imageData: Data, imageName: String) async throws -> PND.UploadMediaResponseModel
  func getImage(id: Int) async throws -> PND.UploadMediaResponseModel
  func uploadImages(imageDatas: [Data]) async throws -> [PND.UploadMediaResponseModel]
}

final class MediaService: MediaServiceProvidable {
  
  typealias Network = PND.Network<PND.API>
  
  private(set) var network: Network = .init()
  
  func uploadImage(imageData: Data, imageName: String = UUID().uuidString) async throws -> PND.UploadMediaResponseModel {
    do {
      return try await network.requestData(.uploadImage(imageData: imageData, imageName: imageName))
    } catch {
      throw PND.ServiceError.uploadImageFailed
    }
  }
  
  func getImage(id: Int) async throws -> PND.UploadMediaResponseModel {
    try await network.requestData(.getMedia(id: id))
  }
  
  func uploadImages(imageDatas: [Data]) async throws -> [PND.UploadMediaResponseModel] {
    var uploadResponse: [PND.UploadMediaResponseModel] = []
    
    for imageData in imageDatas {
      let imageResponse = try await uploadImage(imageData: imageData)
      uploadResponse.append(imageResponse)
    }
    return uploadResponse
  }
}


final class MediaServiceMock: MediaServiceProvidable {
  
  typealias Network = PND.Network<PND.API>
  
  private(set) var network: Network = .init()
  
  func uploadImage(imageData: Data, imageName: String = UUID().uuidString) async throws -> PND.UploadMediaResponseModel {
    do {
      return try await network.requestData(.uploadImage(imageData: imageData, imageName: imageName))
    } catch {
      throw PND.ServiceError.uploadImageFailed
    }
  }
  
  func getImage(id: Int) async throws -> PND.UploadMediaResponseModel {
    try await network.requestData(.getMedia(id: id))
  }
  
  func uploadImages(imageDatas: [Data]) async throws -> [PND.UploadMediaResponseModel] {
    var uploadResponse: [PND.UploadMediaResponseModel] = []
    
    for imageData in imageDatas {
      let imageResponse = try await uploadImage(imageData: imageData)
      uploadResponse.append(imageResponse)
    }
    return uploadResponse
  }
  
}

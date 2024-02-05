//
//  API.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/25.
//

import Foundation
import Moya

extension PND {
  enum API {
    
    //MARK: - Auth
    
    //MARK: - Media
    case uploadImage(imageData: Data, imageName: String)
    case getMedia(id: Int)
    
    //MARK: - Posts
    
    case getSOSPosts(authorId: Int?, page: Int, size: Int, sortBy: String)
    case getSOSPostDetail(id: Int)
    case postSOSPost(model: PND.UrgentPostModel)
    case getSOSConditons
  
    //MARK: - Users
    
    case registerUser(model: PND.UserRegistrationModel)
    case postCheckNickname(nickname: String)
    case getMyProfile
    case postUserStatus(email: String)        // 이메일로 유저의 가입 상태를 조회
    case putMyPets(model: [PND.Pet])
    case getMyPets
    
    //MARK: - Pets
    case getBreeds(pageSize: Int, petType: String)
    
    
  }
}

extension PND.API: Moya.TargetType, AccessTokenAuthorizable {
  
  var baseURL: URL {
    switch PND.Server.shared.currentServerPhase {
    case .dev:  return URL(string: "https://pets-next-door.fly.dev/api")!
    case .prod: return URL(string: "")!
    }
  }
  
  var path: String {
    switch self {
      
      //MARK: - Auth
      
      //MARK: - Media
    case .uploadImage:
      return "/media/images"
    case .getMedia(let id):
      return "/media/\(id)"
      
      
      //MARK: - Posts
    case .getSOSPosts:
      return "/posts/sos"
      
    case .getSOSPostDetail(let id):
      return "/posts/sos/\(id)"
      
    case .postSOSPost(let model):
      return "/posts/sos"
      
    case .getSOSConditons:
      return  "/posts/sos/conditions"
      
      //MARK: - Users
      
    case .registerUser:
      return "/users"
    case .postCheckNickname:
      return "/users/check/nickname"
    case .getMyProfile:
      return "/users/me"
    case .postUserStatus:
      return "/users/status"
    case .putMyPets:
      return "/users/me/pets"
    case .getMyPets:
      return "users/me/pets"
      
      //MARK: - Pets
    case .getBreeds:
      return "/breeds"
    }
  }
  
  var method: Moya.Method {
    switch self {
      
      //MARK: - GET
      
    case .getMyProfile:
      return .get
      
      //MARK: - POST
      
    case .registerUser, .postUserStatus, .uploadImage, .postSOSPost, .postCheckNickname:
      return .post
      
      //MARK: - PUT
      
    case .putMyPets:
      return .put
      
    default:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
      
      //MARK: - Auth
      
      //MARK: - Media
      
    case .uploadImage(let imageData, let imageName):
      let imageFormData = MultipartFormData(
        provider: .data(imageData),
        name: "file",
        fileName: "\(imageName).jpeg",
        mimeType: "image/jpeg"
      )
      return .uploadMultipart([imageFormData])
      
      //MARK: - Posts
      
    case let .getSOSPosts(authorId, page, size, sortBy):
      return .requestParameters(
        parameters: .builder
          .setOptional(key: "authorId", value: authorId)
          .setOptional(key: "page", value: page)
          .setOptional(key: "size", value: size)
          .setOptional(key: "sort_by", value: sortBy)
          .build(),
        encoding: URLEncoding.queryString
      )
      
    case .postSOSPost(let model):
      return .requestParameters(
        parameters: .builder
          .set(key: "care_type", value: model.careType.rawValue)
          .set(key: "carer_gender", value: model.carerGender.rawValue)
          .set(key: "condition_ids", value: model.conditionIds)
          .set(key: "content", value: model.content)
          .set(key: "date_end_at", value: model.dateEndAt)
          .set(key: "date_start_at", value: model.dateStartAt)
          .set(key: "image_ids", value: model.imageIds)
          .set(key: "pet_ids", value: model.petIds)
          .set(key: "reward", value: model.reward)
          .set(key: "reward_amount", value: model.rewardAmount)
          .set(key: "title", value: model.title)
          .build(),
        encoding: JSONEncoding.default
      )

      //MARK: - Users
      
    case .registerUser(let model):
      return .requestParameters(
        parameters: .builder
          .set(key: "email", value: model.email)
          .set(key: "fbProviderType", value: model.fbProviderType.rawValue)
          .set(key: "fbUid", value: model.fbUid)
          .set(key: "fullname", value: model.fullname)
          .set(key: "nickname", value: model.nickname)
          .set(key: "profileImageId", value: model.profileImageId)
          .build(),
        encoding: JSONEncoding.default
      )
      
    case .postCheckNickname(let nickname):
      return .requestParameters(
        parameters: .builder
          .set(key: "nickname", value: nickname)
          .build(),
        encoding: JSONEncoding.default
      )
      
    case .postUserStatus(let email):
      return .requestParameters(
        parameters: .builder
          .set(key: "email", value: email)
          .build(),
        encoding: JSONEncoding.default
      )
      
    case .putMyPets(let models):
      var parameters: [[String : Any]] = [[:]]
      for model in models {
        parameters.append([
          "birth_date" : model.birth_date,
          "breed" : model.breed,
          "name" : model.name,
          "neutered" : model.neutered,
          "pet_type" : model.pet_type.rawValue,
          "sex" : model.sex.rawValue,
          "weight_in_kg" : model.weight_in_kg
        ])
      }
      
      return .requestParameters(
        parameters: .builder
          .set(key: "pets", value: parameters)
          .build(),
        encoding: JSONEncoding.default
      )
      
      //MARK: - Pets
    case let .getBreeds(pageSize, petType):
      return .requestParameters(
        parameters: .builder
          .set(key: "page", value: 1)
          .set(key: "size", value: pageSize)
          .set(key: "pet_type", value: petType)
          .build(),
        encoding: URLEncoding.queryString
      )
      
    default:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    var params: [String : String] = [:]
    switch self {
      
      //MARK: - Auth
      
      //MARK: - Media
    case .uploadImage:
      params["Content-Type"] = "multipart/form-data"
      
      
      //MARK: - Users
      
      //MARK: - Pets
      
    
      
    default:
      params["Content-Type"] = "application/json"
      params["accept"] = "application/json;charset=UTF-8"
      params["Authorization"] = "Bearer \(PNDTokenStore.shared.accessToken)"
    
    }
    return params
  }
  
  var authorizationType: AuthorizationType? { .bearer }
}


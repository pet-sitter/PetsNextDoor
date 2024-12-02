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
    case getMedia(id: String)
    
    //MARK: - Posts
    
    case getSOSPosts(authorId: Int?, page: Int, size: Int, sortBy: String, filterType: String)
    case getSOSPostDetail(id: Int)
    case postSOSPost(model: PND.UrgentPostModel)
    case getSOSConditons
    
    //MARK: - Events
    
    case getEvents(authorId: String?, page: Int, size: Int)
    case putEvent(model: PND.Event)
    case postEvent(model: PND.Event)
    case getEventDetail(id: String)
    case deleteEvent(id: String)
  
    //MARK: - Users
    
    case registerUser(model: PND.UserRegistrationModel)
    case postCheckNickname(nickname: String)
    case getMyProfile
    case postUserStatus(email: String)        // 이메일로 유저의 가입 상태를 조회
    case putMyPets(model: [PND.Pet])
    case getMyPets
    case getUserInfo(userId: String)
    
    //MARK: - Pets
    case getBreeds(pageSize: Int, petType: String)
    
    //MARK: - Chat
    case getChatRooms
    case postChatRoom
    case getChatRoom(roomId: String)
    case postJoinChatRoom(roomId: String)
    case postLeaveChatRoom(roomId: String)
    case getChatRoomMessages(roomId: String, prev: Int?, next: Int?, size: Int)
    
    
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
      
    case .postSOSPost:
      return "/posts/sos"
      
    case .getSOSConditons:
      return  "/posts/sos/conditions"
      
      //MARK: - Events
    case .getEvents:
      return "/events"
      
    case .putEvent:
      return "/events"
      
    case .postEvent:
      return "/events"
      
    case .getEventDetail(let id):
      return "/events/\(id)"
      
    case .deleteEvent(let id):
      return "/events/\(id)"
      
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
    case .getUserInfo(let userId):
      return "users/\(userId)"
      
      //MARK: - Pets
    case .getBreeds:
      return "/breeds"
      
      //MARK: - Chat
    case .getChatRooms:
      return "/chat/rooms"
    case .postChatRoom:
      return "/chat/rooms"
    case .getChatRoom(let roomId):
      return "/chat/rooms/\(roomId)"
    case .postJoinChatRoom(let roomId):
      return "/chat/rooms/\(roomId)/join"
    case .postLeaveChatRoom(let roomId):
      return "/chat/rooms/\(roomId)/leave"
    case let .getChatRoomMessages(roomId, _, _, _):
      return "/chat/rooms/\(roomId)/messages"
    }
  }
  
  var method: Moya.Method {
    switch self {
      
      //MARK: - GET
      
    case .getMyProfile:
      return .get
      
      //MARK: - POST
      
    case .registerUser, .postUserStatus, .uploadImage, .postSOSPost, .postCheckNickname, .postEvent:
      return .post
      
      //MARK: - PUT
      
    case .putMyPets, .putEvent:
      return .put
      
    case .deleteEvent:
      return .delete
      
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
      
    case let .getSOSPosts(authorId, page, size, sortBy, filterType):
      return .requestParameters(
        parameters: .builder
          .setOptional(key: "author_id", value: authorId)
          .setOptional(key: "page", value: page)
          .setOptional(key: "size", value: size)
          .setOptional(key: "sort_by", value: sortBy)
          .setOptional(key: "filter_type", value: filterType)
          .build(),
        encoding: URLEncoding.queryString
      )
      
    case .postSOSPost(let model):
      
      var dateParameters: [[String : String]] = []
      for date in model.dates {
        dateParameters.append([
          "dateStartAt" : date.dateStartAt,
          "dateEndAt"   : date.dateEndAt
        ])
      }
      return .requestParameters(
        parameters: .builder
          .set(key: "careType", value: model.careType.rawValue)
          .set(key: "carerGender", value: model.carerGender.rawValue)
          .set(key: "conditionIds", value: model.conditionIds)
          .set(key: "content", value: model.content)
          .set(key: "dates", value: dateParameters)
          .set(key: "imageIds", value: model.imageIds)
          .set(key: "petIds", value: model.petIds)
          .set(key: "reward", value: model.reward)
          .set(key: "rewardType", value: model.rewardType.rawValue)
          .set(key: "title", value: model.title)
          .build(),
        encoding: JSONEncoding.default
      )
      
      //MARK: - Events
    case let .getEvents(authorId, page, size):
      return .requestParameters(
        parameters: .builder
          .setOptional(key: "authorId", value: authorId)
          .setOptional(key: "page", value: page)
          .set(key: "size", value: size)
          .build(),
        encoding: URLEncoding.queryString
      )
      
    case .putEvent(let model):
      return .requestParameters(
        parameters: .builder
          .setOptional(key: "authorId", value: model.author?.id)
          .set(key: "description", value: model.description)
          .setOptional(key: "fee", value: model.fee)
          .setOptional(key: "genderCondition", value: model.genderCondition)
          .setOptional(key: "maxParticipants", value: model.maxParticipants)
          .setOptional(key: "mediaId", value: model.media.id)
          .set(key: "name", value: model.name)
          .set(key: "recurringPeriod", value: model.recurringPeriod.rawValue)
          .set(key: "startAt", value: model.startAt)
          .set(key: "topics", value: model.topics)
          .build(),
        encoding: JSONEncoding.default
      )
      
    case .postEvent(let model):
      return .requestParameters(
        parameters: .builder
          .setOptional(key: "authorId", value: model.author?.id)
          .set(key: "description", value: model.description)
          .setOptional(key: "fee", value: model.fee)
          .setOptional(key: "genderCondition", value: model.genderCondition)
          .setOptional(key: "maxParticipants", value: model.maxParticipants)
          .setOptional(key: "mediaId", value: model.media.id)
          .set(key: "name", value: model.name)
          .set(key: "recurringPeriod", value: model.recurringPeriod.rawValue)
          .set(key: "startAt", value: model.startAt)
          .set(key: "topics", value: model.topics)
          .set(key: "type", value: model.type.rawValue)
          .build(),
        encoding: JSONEncoding.default
      )
      
//    case .getEventDetail(let id):

      
//    case .deleteEvent(let id):
      
   

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
      var parameters: [[String : Any]] = []
      
      for model in models {
        
        var petDictionary: [String : Any] = [
          "birthDate" : model.birthDate,
          "breed" : model.breed,
          "name" : model.name,
          "neutered" : model.neutered,
          "petType" : model.petType.rawValue,
          "sex" : model.sex.rawValue,
          "weightInKg" : model.weightInKg,
        ]
  
        if let profileImageId = model.profileImageId {
          petDictionary["profileImageId"] = profileImageId
        }
        
        if let remarks = model.remarks {
          petDictionary["remarks"] = remarks
          
        }
        parameters.append(petDictionary)
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
      
      
      //MARK: - Chat
    case let .getChatRoomMessages(roomId, prev, next, size):
      return .requestParameters(
        parameters: .builder
          .setOptional(key: "prev", value: prev)
          .setOptional(key: "next", value: next)
          .set(key: "size", value: size)
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
      ()
//      params["Content-Type"] = "application/json"
//      params["accept"] = "application/json;charset=UTF-8"
//      params["Authorization"] = "Bearer \(PNDTokenStore.shared.accessToken)"
    
    }
    return params
  }
  
  var authorizationType: AuthorizationType? { .bearer }
}


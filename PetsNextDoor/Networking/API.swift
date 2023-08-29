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
    
    
  
    //MARK: - Users
    
    case registerUser(model: PND.UserRegistrationModel)
    case getMyProfile
    case postUserStatus(email: String)
    
    //MARK: - Pets
    
  }
}

extension PND.API: Moya.TargetType {
  
  var baseURL: URL {
    switch PND.Server.shared.currentServerPhase {
    case .dev:  return URL(string: "https://pets-next-door-api-dev.onrender.com/api")!
    case .prod: return URL(string: "")!
    }
  }
  
  var path: String {
    switch self {
      
      //MARK: - Auth
      
      //MARK: - Media
      
      
    
      //MARK: - Users
      
    case .registerUser:
      return "/users"
    case .getMyProfile:
      return "/users/me"
    case .postUserStatus:
      return "/users/status"
      
      //MARK: - Pets
    }
  }
  
  var method: Moya.Method {
    switch self {
      
      //MARK: - GET
      
    case .getMyProfile:
      return .get
      
      //MARK: - POST
      
    case .registerUser, .postUserStatus:
      return .post
      

    default:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
      
      //MARK: - Auth
      
      //MARK: - Media
      
      
      //MARK: - Users
      
    case .registerUser(let model):
      return .requestParameters(
        parameters: .builder
          .set(key: "email", value: model.email)
          .set(key: "fbProviderType", value: model.fbProviderType.rawValue)
          .set(key: "fbUid", value: model.fbUid)
          .set(key: "fullname", value: model.fullname)
          .set(key: "nickname", value: model.nickname)
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
      
      //MARK: - Pets
      
      
    default:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    var params: [String : String] = [:]
    switch self {
      
      //MARK: - Auth
      
      //MARK: - Media
      
      
      
      //MARK: - Users
      
      //MARK: - Pets
      
    
      
    default:
      params["Content-Type"] = "application/json"
      params["accept"] = "application/json;charset=UTF-8"
    
    }
    return params
  }
}


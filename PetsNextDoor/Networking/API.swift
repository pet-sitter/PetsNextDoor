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
    case .getMyProfile:
      return "/users/me"
    case .postUserStatus:
      return "/users/status"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getMyProfile:
      return .get
      
    case .postUserStatus:
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
      break 
    }
    return params
  }
}


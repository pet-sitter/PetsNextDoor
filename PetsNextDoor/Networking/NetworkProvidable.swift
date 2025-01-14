//
//  Network.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/25.
//

import Foundation
import Moya

// Jin - ???: PNDMoyaProvidable이 나을지도..

protocol NetworkProvidable {
  associatedtype APITarget: Moya.TargetType
  var provider: MoyaProvider<APITarget> { get }
}

protocol PNDNetworkProvidable {
  associatedtype Network: NetworkProvidable where Network.APITarget == PND.API
  var network: Network { get }
}

extension NetworkProvidable {
  
  @discardableResult
  func plainRequest(_ target: APITarget) async throws -> Response {
    try await withCheckedThrowingContinuation { continuation in
      _Concurrency.Task {
        provider.request(target, callbackQueue: DispatchQueue.global()) { result in
          switch result {
          case let .success(response):
            do {
              let networkResponse = try response.filterSuccessfulStatusCodes()
              print("🛜 Network Success: \(networkResponse) for target: \(target)")
              continuation.resume(returning: networkResponse)
            } catch(let error) {
              
              if error.isUnauthorizedError {
                print("❌ Unauthorized error: \(error) - token refresh needed")
                
                LoginService.shared.refreshToken { error in
                  
                  if let error {
                    if error == .onRefreshTokenFailure {
                      LoginService.shared.logout()
                    }
                    continuation.resume(throwing: error)
                  }
                  
                  print("✅ Refresh Token success to: \(PNDTokenStore.shared.accessToken)")
                  
                  provider.request(target, callbackQueue: DispatchQueue.global()) { result in
                    switch result {
                    case let .success(response):
                      
                      do {
                        let networkResponse = try response.filterSuccessfulStatusCodes()
                        continuation.resume(returning: networkResponse)
                      } catch {
                        continuation.resume(throwing: error)
                      }

                    case let .failure(moyaError):
                      continuation.resume(throwing: moyaError)
                    }
                  }
                }
              } else {
                print("❌ Network Error: \(error) for target: \(target)")
                continuation.resume(throwing: error)
              }
              
            }
          case let .failure(moyaError):
            continuation.resume(throwing: moyaError)
          }
        }
      }
    }
  }
  
  @discardableResult
  func requestData<ResponseData: Decodable>(_ target: APITarget) async throws -> ResponseData {
    try await withCheckedThrowingContinuation { continuation in
      _Concurrency.Task {
        provider.request(target, callbackQueue: DispatchQueue.global()) { result in
          switch result {
          case let .success(response):
            do {

              printJSONObjectIfPossible(using: response.data)
              
              let _ = try response.filterSuccessfulStatusCodes()
              let responseData = try response.map(ResponseData.self)
              print("🛜 Network Success: \(response) for target: \(target)")
              continuation.resume(returning: responseData)
            } catch {

              if error.isUnauthorizedError {
                print("❌ Unauthorized error: \(error) - token refresh needed")
                
                LoginService.shared.refreshToken { error in
                  
                  if let error {
                    if error == .onRefreshTokenFailure {
                      LoginService.shared.logout()
                    }
                    continuation.resume(throwing: error)
                    return
                  }
                  
                  print("✅ Refresh Token success to: \(PNDTokenStore.shared.accessToken)")
                  
                  provider.request(target, callbackQueue: DispatchQueue.global()) { result in
                    switch result {
                    case let .success(response):
                      
                      do {
                        
                        printJSONObjectIfPossible(using: response.data)
                        
                        let _ = try response.filterSuccessfulStatusCodes()
                        let responseData = try response.map(ResponseData.self)
                        print("🛜 Network Success: \(response) for target: \(target)")
                        continuation.resume(returning: responseData)
                        
                        
                      } catch {
                        continuation.resume(throwing: error)
                      }

                    case let .failure(moyaError):
                      continuation.resume(throwing: moyaError)
                    }
                  }
                }
              } else {
                print("❌ Network Error: \(error) for target: \(target)")
                continuation.resume(throwing: error)
              }
        
            }
          case let .failure(moyaError):
            print("❌ Moya Error: \(moyaError)")
            continuation.resume(throwing: moyaError)
          }
        }
      }
    }
  }
  
  
  
  
  private func mapResponseData<ResponseData: Decodable>(response: Response) throws -> ResponseData {
    
    printJSONObjectIfPossible(using: response.data)
    
    let _ = try response.filterSuccessfulStatusCodes()
    let responseData = try response.map(ResponseData.self)
    return responseData
  }
  
  private func printJSONObjectIfPossible(using data: Data) {
    if let json = try? JSONSerialization.jsonObject(
      with: data,
      options: .mutableContainers
    ) {
      print("✅ JSON: \(json)")
    }
  }
}

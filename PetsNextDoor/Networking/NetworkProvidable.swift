//
//  Network.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/25.
//

import Foundation
import Moya

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
              continuation.resume(returning: networkResponse)
            } catch {
              continuation.resume(throwing: error)
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
              let _ = try response.filterSuccessfulStatusCodes()
              let responseData = try response.map(ResponseData.self)
              continuation.resume(returning: responseData)
            } catch {
              continuation.resume(throwing: error)
            }
          case let .failure(moyaError):
            continuation.resume(throwing: moyaError)
          }
        }
      }
    }
  }
}

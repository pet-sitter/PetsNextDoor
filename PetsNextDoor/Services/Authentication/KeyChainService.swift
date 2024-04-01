//
//  KeyChainManager.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/01.
//

import Foundation
import Dependencies

enum KeychainKey: String {
  case accessToken
  case refreshToken
}


protocol KeyChainProvidable {
  func save(_ keyChainKey: KeychainKey, _ stringData: String)
  func read(_ keyChainKey: KeychainKey) -> String?
  func delete(_ keyChainKey: KeychainKey)
}


struct KeychainService: KeyChainProvidable {
  
  private let controller = KeychainController()
  
  func save(_ keyChainKey: KeychainKey, _ stringData: String) {
    let data = stringData.data(using: .utf8)
    if let _ = controller.read(keyChainKey) {
      controller.update(data, key: keyChainKey)
      return
    }
    controller.create(data, key: keyChainKey)
  }
  
  func read(_ keyChainKey: KeychainKey) -> String? {
    guard let data = controller.read(keyChainKey) else { return nil }
    return String(data: data, encoding: .utf8)
  }
  
  func delete(_ keyChainKey: KeychainKey) {
    controller.delete(keyChainKey)
  }

}


private struct KeychainController {
  
  private let service: String = "PND"
  
  func create(_ data: Data?, key: KeychainKey) {
    guard let data = data else {
      print("🗝️ '\(key)' Data nil")
      return
    }
    
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: key.rawValue,
      kSecValueData: data
    ]
    
    let status = SecItemAdd(query, nil)
    guard status == errSecSuccess else {
      print("🗝️ '\(key)' Status = \(status)")
      return
    }
    print("🗝️ '\(key)' Success!")
  }

  
  func read(_ key: KeychainKey) -> Data? {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: key.rawValue,
      kSecMatchLimit: kSecMatchLimitOne,
      kSecReturnData: true
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query, &result)
    guard status != errSecItemNotFound else {
      print("🗝️ '\(key)' Item Not Found")
      return nil
    }
    guard status == errSecSuccess else {
      return nil
    }
    print("🗝️ '\(key)' Success!")
    return result as? Data
  }
  
  func update(_ data: Data?, key: KeychainKey) {
    guard let data = data else {
      print("🗝️ '\(key)' Data nil")
      return
    }
    
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: key.rawValue
    ]
    let attributes: NSDictionary = [
      kSecValueData: data
    ]
    
    let status = SecItemUpdate(query, attributes)
    guard status == errSecSuccess else {
      print("🗝️ '\(key)' Status = \(status)")
      return
    }
    print("🗝️ '\(key)' Success!")
  }
  
  func delete(_ key: KeychainKey) {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: key.rawValue
    ]
    
    let status = SecItemDelete(query)
    guard status != errSecItemNotFound else {
      print("🗝️ '\(key)' Item Not Found")
      return
    }
    guard status == errSecSuccess else {
      return
    }
    print("🗝️ '\(key)' Success!")
  }
}

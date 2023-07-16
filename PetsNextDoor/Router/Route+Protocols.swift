//
//  OutputStreamObservable.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/15.
//

import Foundation
import Combine

protocol Routable: OutputStreamObservable {
  @MainActor func route(to screen: ScreenType)
}

protocol OutputStreamObservable {
  var outputStream: AsyncPublisher<PassthroughSubject<ObservableOutput, Never>> { get }
  func observeOutputStream()
}

import UIKit

enum ScreenType {
  case main(onWindow: UIWindow)
  case login(onWindow: UIWindow)
  case authenticatePhoneNumber
  case setInitialProfile
  case addPet

}

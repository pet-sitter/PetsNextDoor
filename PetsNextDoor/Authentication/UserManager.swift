//
//  UserManager.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/07/04.
//

import Foundation

protocol UserManageable {
    func logout() async
}

actor UserManager: UserManageable {
    
    static let shared = UserManager()
    
    
    // isLoggedIn
    
    private init() {}
    
    
    func logout() {
        
    }

}

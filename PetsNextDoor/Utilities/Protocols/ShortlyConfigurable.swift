//
//  ShortlyConfigurable.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 2023/07/04.
//

import Foundation

protocol ShortlyConfigurable: AnyObject {}

extension ShortlyConfigurable {
    
    @inlinable
    @discardableResult
    func `set`(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

extension NSObject: ShortlyConfigurable {}

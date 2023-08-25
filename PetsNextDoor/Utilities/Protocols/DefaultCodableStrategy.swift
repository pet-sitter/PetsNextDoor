//
//  DefaultCodableStrategy.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/08/25.
//

import Foundation

/// Provides a default value for missing `Decodable` data.
///
/// `DefaultCodableStrategy` provides a generic strategy type that the `DefaultCodable` property wrapper can use to provide a reasonable default value for missing Decodable data.
public protocol DefaultCodableStrategy {
  associatedtype RawValue: Codable
  
  static var defaultValue: RawValue { get }
}

/// Decodes values with a reasonable default value
///
/// `@Defaultable` attempts to decode a value and falls back to a default type provided by the generic `DefaultCodableStrategy`.
@propertyWrapper
public struct DefaultCodable<Default: DefaultCodableStrategy>: Codable {
  public var wrappedValue: Default.RawValue
  
  public init(wrappedValue: Default.RawValue) {
    self.wrappedValue = wrappedValue
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.wrappedValue = (try? container.decode(Default.RawValue.self)) ?? Default.defaultValue
  }
  
  public func encode(to encoder: Encoder) throws {
    try wrappedValue.encode(to: encoder)
  }
}

extension DefaultCodable: Equatable where Default.RawValue: Equatable { }
extension DefaultCodable: Hashable where Default.RawValue: Hashable { }

// MARK: - KeyedDecodingContainer
public extension KeyedDecodingContainer {

  /// Default implementation of decoding a DefaultCodable
  ///
  /// Decodes successfully if key is available if not fallsback to the default value provided.
  func decode<P>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
    if let value = try decodeIfPresent(DefaultCodable<P>.self, forKey: key) {
      return value
    } else {
      return DefaultCodable(wrappedValue: P.defaultValue)
    }
  }
}

/// Decodes Bools defaulting to `false` if applicable
///
/// `@DefaultFalse` decodes Bools and defaults the value to false if the Decoder is unable to decode the value.
public typealias DefaultFalse = DefaultCodable<DefaultFalseStrategy>
public struct DefaultFalseStrategy: DefaultCodableStrategy {
  public static var defaultValue: Bool { return false }
}

/// Decodes Bools defaulting to `true` if applicable
///
/// `@DefaultFalse` decodes Bools and defaults the value to true if the Decoder is unable to decode the value.
public typealias DefaultTrue = DefaultCodable<DefaultTrueStrategy>
public struct DefaultTrueStrategy: DefaultCodableStrategy {
  public static var defaultValue: Bool { return true }
}

/// Decodes Strings defaulting to `Empty String` if applicable
///
/// `@DefaultEmptyString` decodes Strings and defaults the value to "" if the Decoder is unable to decode the value.
public typealias DefaultEmptyString = DefaultCodable<DefaultEmptyStringStrategy>
public struct DefaultEmptyStringStrategy: DefaultCodableStrategy {
  public static var defaultValue: String { return "" }
}

/// Decodes Array defaulting to `Empty Array` if applicable
///
/// `@DefaultEmptyArry` decodes Array and defaults the value to [] if the Decoder is unable to decode the value.
public typealias DefaultEmptyArray<T> = DefaultCodable<DefaultEmptyArrayStrategy<T>> where T: Codable
public struct DefaultEmptyArrayStrategy<T: Codable>: DefaultCodableStrategy {
  public static var defaultValue: [T] { return [] }
}

/// Decodes Int defaulting to `zero` if applicable
///
/// `@DefaultZero` decodes Int and defaults the value to 0 if the Decoder is unable to decode the value.
public typealias DefaultZero = DefaultCodable<DefaultZeroStrategy>
public struct DefaultZeroStrategy: DefaultCodableStrategy {
  public static var defaultValue: Int { return 0 }
}

/// Decodes Int defaulting to `zero` if applicable
///
/// `@DefaultZeroWithDouble` decodes Int and defaults the value to 0 if the Decoder is unable to decode the value.
public typealias DefaultZeroWithDouble = DefaultCodable<DefaultZeroWithDoubleStrategy>
public struct DefaultZeroWithDoubleStrategy: DefaultCodableStrategy {
  public static var defaultValue: Double { return 0 }
}

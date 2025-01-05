//
//  PND+Models.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 11/29/23.
//

import Foundation

extension PND {
	
  enum PetType: String, Codable, Hashable {
		case dog = "dog"
		case cat = "cat"
    
    enum CodingKeys: String, CodingKey {
      case dog, cat
    }
    
    init(from decoder: Decoder) throws {
      self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .dog
    }
	}
  
  enum GenderType: String, Codable  {
    case male   = "male"
    case female = "female"
    case all    = "all"    // 상관없음 
  }
  

  enum EventDuration: String {
    case daily    = "매일"
    case weekly   = "매주"
    case biWeekly = "2주에 한 번"
    case monthly  = "매달"
    
    func asRecurringPeriod() -> PND.RecurringPeriod {
      switch self {
      case .daily:
        return .daily
      case .weekly:
        return .weekly
      case .biWeekly:
        return .biweekly
      case .monthly:
        return .monthly
      }
    }
  }
  
  struct EventUploadModel: Equatable {
    
    var eventType: PND.EventType? = nil
    var eventDuration: PND.EventDuration? = nil
    var eventDate: Foundation.Date? = nil
    var eventSubject: String? = nil
    var eventParticipants: Int? = nil
    var eventFee: Int? = nil
    var eventAddress: String? = nil
    var eventJibunAddress: String? = nil
    var eventAddressDetail: String? = nil
    var eventTitle: String? = nil
    var eventDescription: String? = nil
    var selectedImageDatas: [Data] = []
    var eventMediaId: String? = nil
    
    func asEvent() -> PND.Event {
      PND.Event(
        author: nil,
        createdAt: nil,
        description: eventDescription ?? "",
        fee: eventFee,
        genderCondition: nil,
        id: "",
        maxParticipants: eventParticipants,
        media: PND.Media(id: eventMediaId ?? "", mediaType: nil),
        name: eventTitle ?? "",
        recurringPeriod: eventDuration?.asRecurringPeriod(),
        startAt: DateConverter.formatDateToISO8601Format(date: eventDate ?? Foundation.Date()),
        topics: [eventSubject ?? ""],
        type: eventType ?? .shortTerm,
        updatedAt: nil
      )
    }
  }
  
  enum ChatRoomType: Equatable {
    case eventChat(PND.EventType) // 이벤트 채팅
    case urgentPostChat // 돌봄 급구 채팅
    
    var queryValue: String {
      switch self {
      case .eventChat(let eventType):
        switch eventType {
        case .shortTerm: // 단기 이벤트
          return "EVENT-\(PND.EventType.shortTerm.rawValue)"
        case .recurring: // 정기 이벤트
          return "EVENT-\(PND.EventType.recurring.rawValue)"
        }
      case .urgentPostChat:
        return "URGENTPOST"
      }
    }
  }
}

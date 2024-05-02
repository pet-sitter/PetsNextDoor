//
//  DateConverter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/09/03.
//

import Foundation

struct DateConverter {
  
  static func calculateAge(_ dateString: String) -> Int {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    if let birthDate = dateFormatter.date(from: dateString) {

      let calendar = Calendar.current
      let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
      
      if let age = ageComponents.year {
        return age
      }
    }
    
    return 0
  }
  
  static func convertDateToString(date: Date, _ dateFormat: String = "yyyy-MM-dd") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    let dateString = dateFormatter.string(from: date)
    return dateString
  }
  
  static func convertDateComponentsToPNDDateModel(_ dateComponents: Set<DateComponents>) -> [PND.Date] {
    return dateComponents
      .compactMap(\.date)
      .map { convertDateToString(date: $0) }
      .map { PND.Date(dateStartAt: $0, dateEndAt: $0) }
  }
  
  static func calculateDDay(using dateString: String?) -> Int? {
    guard let dateString else { return nil }
    
    let dateFormat = "yyyy-MM-dd"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    let currentDate = Date()
    
    if let targetDate = dateFormatter.date(from: dateString) {
      
      let components = Calendar.current.dateComponents(
        [.day],
        from: currentDate,
        to: targetDate
      )
      
      if let daysLeft = components.day {
        return daysLeft
      } else {
        return nil
      }
    } else {
      return nil
    }
  }
  
}

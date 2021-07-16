//
//  Date.swift
//  Statist
//
//  Created by Kimyaehoon on 05/07/2021.
//

import Foundation

extension Date: Identifiable {
    public var id: String {
        return titleString()
    }
    
    func titleString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
    
    func toDay() -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
    }
    
    func nextMonth() -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: 1, to: self) ?? self
        return newDate
    }
    
    func nextWeek() -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: 7, to: self) ?? self
        return newDate
    }
    
    func prevMonth() -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .month, value: -1, to: self) ?? self
        return newDate
    }
    
    func prevWeek() -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: -7, to: self) ?? self
        return newDate
    }
}

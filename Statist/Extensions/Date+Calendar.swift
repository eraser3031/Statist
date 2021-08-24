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
    
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.string(from: self)
    }
    
    var toDay: Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
    }
    
    func nextDay() -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: 1, to: self) ?? self
        return newDate
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

extension Calendar {
    func generateDates(start: Date, end: Date, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
//        dates.append(start)
        enumerateDates(startingAfter: start,
                       matching: components,
                       matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date <= end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
    
    func distanceByDay(start: Date, end: Date) -> Int {
        return dateComponents([.day], from: start, to: end).day ?? 0
    }
}

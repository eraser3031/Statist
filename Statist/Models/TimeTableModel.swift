//
//  TimeTableItem.swift
//  Statist
//
//  Created by Kimyaehoon on 07/07/2021.
//

import SwiftUI

struct TimeTableModel {
    
    typealias Line = (hour: Int, offset: CGFloat, width: CGFloat)
    
    let id = UUID().uuidString
    var kind: Kind
    var interval: DateInterval
    
    init(kind: Kind, interval: DateInterval){
        self.kind = kind
        self.interval = interval
    }
    
    func toLine() -> [Line] {
        
        var lines: [Line] = []
        let start = interval.start
        let end = interval.end
        
        var middles: [Date] = []
        
        let calendar = Calendar.current
        
        calendar
            .enumerateDates(startingAfter: interval.start,
                            matching: DateComponents(minute: 0, second: 0),
                            matchingPolicy: .nextTime) { date, _, stop in
                if let date = date {
                    if date < interval.end {
                        middles.append(date)
                    } else {
                        stop = true
                    }
                }
            }
        
        if middles.count == 0 {
            let width: CGFloat = CGFloat(calendar.dateComponents([.minute], from: start, to: end).minute ?? 0) / 60.0 * 100.0
            let offset: CGFloat = CGFloat(calendar.dateComponents([.minute], from: start).minute ?? 0) / 60.0 * 100.0
            let hour: Int = calendar.dateComponents([.hour], from: start).hour ?? 0
            lines.append(Line(hour: hour, offset: offset, width: width))
        } else {
            for i in 0...middles.count {
                
                let width: CGFloat = CGFloat(
                    calendar.dateComponents([.minute],
                                            from: i == 0 ? start : middles[i-1],
                                            to: i == middles.count ? end : middles[i])
                                            .minute ?? 0
                                        ) / 60.0 * 100.0
                
                let offset: CGFloat = i == 0 ? (CGFloat(calendar.dateComponents([.minute], from: start).minute ?? 0) / 60.0 * 100.0) : 0
                let hour: Int = calendar.dateComponents([.hour], from: i == 0 ? start : middles[i-1]).hour ?? 0
                lines.append(Line(hour: hour, offset: offset, width: width))
            }
        }
        
        return lines
    }
}

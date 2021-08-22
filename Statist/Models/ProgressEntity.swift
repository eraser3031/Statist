//
//  ProgressEntity.swift
//  Statist
//
//  Created by Kimyaehoon on 20/07/2021.
//

import SwiftUI

extension GoalEntity {
    var now: Int {
        guard let times = times else { return 0 }
        return times.count
    }
    
    var percentForCalcurate: CGFloat {
        CGFloat(now) / CGFloat(goal) 
    }
    
    var percent: Int {
        return Int(Float(now) / Float(goal) * 100)
    }
    
    var isFinish: Bool {
        return now >= Int(goal)
    }
    
    var isFailed: Bool {
        return Date().toDay > (endDate ?? Date().toDay)
    }
}
//extension ProgressEntity {
//    var percent: Int {
//        return Int(Float(self.now) / Float(self.goal) * 100)
//    }
//    
//    var now: Int {
//        let data = getProgressPoints()
//        return data.reduce(0) { result, point in
//            return result + Int(point.count)
//        }
//    }
//    
//    var isFinish: Bool {
//        return self.now >= Int(self.goal)
//    }
//    
//    var isNotFinish: Bool {
//        return !isFinish
//    }
//    
//    func getProgressPoints() -> [ProgressPoint] {
//        return self.progressPoints?.allObjects as? [ProgressPoint] ?? []
//    }
//    
//    func findPoint(_ date: Date) -> ProgressPoint? {
//        let data = getProgressPoints()
//        return data.first(where: { $0.date == date })
//    }
//}

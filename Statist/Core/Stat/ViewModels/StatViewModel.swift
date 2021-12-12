//
//  StatViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 11/12/2021.
//

import SwiftUI
import Combine
import CoreData

/*
 자 생각해보자.
 스탯 뷰에서 필요한 목록
 1. 미완료한 투두들 -> 기간, 종류 / 수정 가능해야 함.
 2. 종류 별 시간 투자량 -> 기간
 3. 목표 그래프 -> 기간, 아이템 별
 
 위에서 기간 선택 가능하게 하자 전부 기간에 따라 달라지는 아이템이니까
 
 -프로퍼티-
 1. 쿼리기간
 2. 투두들 [ 종류 배열 ]
 3. 종류 별 투자량 [ 종류 배열 ]
 4. 목표 데이터 [ 아이템 배열 ]
 
 -메소드-
 1. 투두 변경 ( 클릭하면 바로 업데이트? ㄴㄴ 그럼 바로 사라지니까 화면 나갈때까지 유예기간 줘야 됨 )
 1.5. 투두 삭제 ( 클릭하면 바로 업데이트? ㄴㄴ 그럼 바로 사라지니까 화면 나갈때까지 유예기간 줘야 됨 )
 2. 목표 데이터 그래프 친화적 데이터 변환
 3. 코어데이터 저장
 */
import OrderedCollections

class StatViewModel: ObservableObject {
    @Published var period: DateInterval
    @Published var delayedTodoes: [TodoEntity] = []
    @Published var accumulatedTimes: [KindEntity : [Int]] = [:]
    @Published var goals: [GoalEntity] = []
    var circleChartData: OrderedDictionary<KindEntity, Int> = [:]
    
    let manager = CoreDataManager.instance
    
    init() {
        self.period = DateInterval(start: Date().toDay.prevWeek(), end: Date().toDay)
        getDelayedTodoes()
        getAccumulatedTimes()
    }
    
    func getDelayedTodoes(context: NSManagedObjectContext = CoreDataManager.instance.context) {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        let filter = NSPredicate(format: "date > %@ AND date < %@ AND isDone == false" , period.start as NSDate, period.end as NSDate)
        request.predicate = filter

        do {
            let result = try context.fetch(request)
            delayedTodoes = result
        } catch let error {
            print("Error Fetching entities: \(error)")
        }
    }
    
    func inverseIsDone(context: NSManagedObjectContext = CoreDataManager.instance.context, of todo: TodoEntity) {
        todo.isDone = !todo.isDone
        save() // 과연 원하는 대로 뷰만 변하는 지 확인
    }
    
    func delete(context: NSManagedObjectContext = CoreDataManager.instance.context, todo: TodoEntity) {
        context.delete(todo)
        saveAndLoad(context: context)
    }
    
    func getAccumulatedTimes(context: NSManagedObjectContext = CoreDataManager.instance.context) {
        let request = NSFetchRequest<TimetableEntity>(entityName: "TimetableEntity")
        let filter = NSPredicate(format: "date > %@ AND date < %@" , period.start as NSDate, period.end as NSDate)
        request.predicate = filter
        
        var tempTimes: [KindEntity : [Int]] = [:]
        
        do {
            let result = try context.fetch(request)
            result.forEach { entity in
                if let kind = entity.kindEntity {
                    tempTimes[kind, default: []].append(Int(entity.duration))
                }
            }
            accumulatedTimes = tempTimes
            
            tempTimes.forEach { key, value in
                circleChartData[key] = value.reduce(0, +)
            }
            
            circleChartData.sort { $0.value > $1.value }
            
        } catch let error {
            print("Error Fetching entities: \(error)")
        }
    }
    
    func calPercent(by kind: KindEntity) -> Double {
        let value = Double(circleChartData[kind] ?? 0)
        let percent = value / Double(circleChartData.values.reduce(0, +))
        return percent * 100
    }
    
    func calPercent(by kinds: [KindEntity]) -> Double {
        var value = 0.0
        kinds.forEach { kind in
            value += Double(circleChartData[kind, default: 0])
        }
        let percent = value / Double(circleChartData.values.reduce(0, +))
        return percent * 100
    }
    
//    func getGoals(context: NSManagedObjectContext = CoreDataManager.instance.context) {
//        let request = NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
//        let filter = NSPredicate(format:"endDate > %@", Date().toDay as NSDate)
//        request.predicate = filter
//
//        do {
//            let result = try context.fetch(request)
//            goals = result
//        } catch let error {
//            print("Error Fetching entities: \(error)")
//        }
//    }
    
//    func decodeGoalsToGraph() {
//        // chart *시작 데이트, *엔드 데이트, [배열 <- 인트인덱스/회수], *총목표회수
//    }
    
    func saveAndLoad(context: NSManagedObjectContext = CoreDataManager.instance.context) {
        save(context: context)
        getDelayedTodoes(context: context)
    }
    
    func save(context: NSManagedObjectContext = CoreDataManager.instance.context) {
        do {
            try context.save()
        } catch {
            print("error save: \(#function)")
        }
    }
}

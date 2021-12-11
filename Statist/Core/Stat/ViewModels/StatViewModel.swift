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

class StatViewModel: ObservableObject {
    @Published var period: DateInterval
    @Published var delayedTodoes: [TodoEntity] = []
    @Published var accumulatedTimes: [TimetableEntity : Int] = [:]
    @Published var goals: [GoalEntity] = []
    
    let manager = CoreDataManager.instance
    
    init() {
        self.period = DateInterval(start: Date().toDay.prevWeek(), end: Date().toDay)
    }
    
    func getDelayedTodoes(context: NSManagedObjectContext) {
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
    
    func inverseIsDoneOfTodo(context: NSManagedObjectContext, todo: TodoEntity) {
        todo.isDone = !todo.isDone
        saveAndLoad(context: context)
    }
    
    func deleteTodo() { }
    
    func getAccumulatedTimes() { }
    
    func getGoals() { }
    
    func decodeGoalsToGraph() { }
    
    func saveAndLoad(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("error saveAndLoad: \(#function)")
        }
        getDelayedTodoes(context: context)
    }
}

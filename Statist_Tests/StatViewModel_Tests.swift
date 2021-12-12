//
//  StatViewModel_Tests.swift
//  Statist_Tests
//
//  Created by Kimyaehoon on 11/12/2021.
//

import XCTest
import CoreData
@testable import Statist

class StatViewModel_Tests: XCTestCase {
    
    var viewModel: StatViewModel?
    var preview: CoreDataManager?
    var context: NSManagedObjectContext?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = StatViewModel()
        preview = CoreDataManager(inMemory: true)
        context = preview?.container.newBackgroundContext()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        preview = nil
        context = nil
    }

    func test_StatViewModel_getDelayedTodoes_shouldGetItem(){
        //Given
        guard let vm = viewModel, let preview = preview, let context = context else {
            XCTFail()
            return
        }
        
        XCTAssertNotEqual(vm.period.start, vm.period.end)
        let todoItem = TodoEntity(context: context)
        let kind = KindEntity(context: context)
        kind.id = UUID().uuidString
        kind.name = "dd"
        todoItem.id = UUID().uuidString
        todoItem.isDone = false
        todoItem.date = Date().toDay.nextDay().prevWeek()
        todoItem.name = "hello"
        todoItem.kindEntity = kind
        todoItem.event = nil
        todoItem.id = UUID().uuidString
        do {
            try context.save()
        } catch {
            XCTFail()
        }
        
        //When
        vm.getDelayedTodoes(context: context)
        let returnedItem = vm.delayedTodoes.first
        
        //Then
        XCTAssertEqual(vm.delayedTodoes.count, 1)
        XCTAssertEqual(todoItem.id!, returnedItem?.id ?? "")
    }
    
    func test_StatViewModel_getDelayedTodoes_shouldNotGetItem(){
        //Given
        guard let vm = viewModel, let preview = preview, let context = context else {
            XCTFail()
            return
        }
        
        let lateTodoItem = TodoEntity(context: context)
        let futureTodoItem = TodoEntity(context: context)
        let doneTodoItem = TodoEntity(context: context)
        
        let kind = KindEntity(context: context)
        kind.id = UUID().uuidString
        kind.name = "dd"
        
        lateTodoItem.id = UUID().uuidString
        lateTodoItem.kindEntity = kind
        lateTodoItem.isDone = false
        lateTodoItem.date = Date().toDay.prevWeek() //
        lateTodoItem.name = "test"
        lateTodoItem.event = nil
        
        futureTodoItem.id = UUID().uuidString
        futureTodoItem.kindEntity = kind
        futureTodoItem.isDone = false
        futureTodoItem.date = Date().toDay //
        futureTodoItem.name = "test"
        futureTodoItem.event = nil
        
        doneTodoItem.id = UUID().uuidString
        doneTodoItem.kindEntity = kind
        doneTodoItem.isDone = true //
        doneTodoItem.date = Date().toDay.nextDay().prevWeek()
        doneTodoItem.name = "test"
        doneTodoItem.event = nil
        
        do {
            try context.save()
        } catch {
            XCTFail()
        }
        
        //When
        vm.getDelayedTodoes(context: context)
        
        //Then
        XCTAssertEqual(vm.delayedTodoes.count, 0)
    }
    
    func test_StatViewModel_inverseIsDoneOfTodo_shouldBeInversed(){
        //Given
        guard let vm = viewModel, let preview = preview, let context = context else {
            XCTFail()
            return
        }
        let delayedTodoItem = TodoEntity(context: context)
        
        let kind = KindEntity(context: context)
        kind.id = UUID().uuidString
        kind.name = "dd"
        
        delayedTodoItem.id = UUID().uuidString
        delayedTodoItem.kindEntity = kind
        delayedTodoItem.isDone = false
        delayedTodoItem.date = Date().toDay.prevWeek().nextDay()
        delayedTodoItem.name = "test"
        delayedTodoItem.event = nil
        
        do {
            try context.save()
        } catch {
            XCTFail()
        }
        
        vm.getDelayedTodoes(context: context)
        XCTAssertEqual(vm.delayedTodoes.count, 1)
        
        // When
        vm.inverseIsDone(context: context, of: delayedTodoItem)
        
        // Then
        XCTAssertEqual(vm.delayedTodoes.count, 0)
    }
    
    func test_StatViewModel_delete_shouldBeDelete(){
        //Given
        guard let vm = viewModel, let preview = preview, let context = context else {
            XCTFail()
            return
        }
        
        let kind = KindEntity(context: context)
        kind.id = UUID().uuidString
        kind.name = "dd"
        
        let item = TodoEntity(context: context)
        item.id = UUID().uuidString
        item.isDone = false
        item.kindEntity = kind
        item.date = Date().toDay.prevWeek().nextDay()
        item.name = "test"
        item.event = nil
        
        vm.saveAndLoad(context: context)
        XCTAssertEqual(item.id, vm.delayedTodoes.first?.id ?? "")
        XCTAssertEqual(vm.delayedTodoes.count, 1)
        
        //When
        vm.delete(context: context, todo: item)
        vm.saveAndLoad(context: context)
        
        //Then
        XCTAssertEqual(vm.delayedTodoes.count, 0)
    }
    
    func test_StatViewModel_getAccumulatedTimes_shouldBeCorrectCalculatingTime() {
        //Given
        guard let vm = viewModel, let _ = preview, let context = context else {
            XCTFail()
            return
        }
        
        var answer: [KindEntity : [Int]] = [:]
        
        let study = KindEntity(context: context)
        study.id = UUID().uuidString
        study.name = "study"
        study.colorKindID = ColorKind.blue.rawValue
        
        let game = KindEntity(context: context)
        game.id = UUID().uuidString
        game.name = "game"
        game.colorKindID = ColorKind.red.rawValue
        
        for _ in 1..<10 {
            let returnedValue = makeTimetable(context: context, kinds: [study, game])
            if let kind = returnedValue.0 {
                answer[kind, default: []].append(returnedValue.1)
            }
        }
        
        //When
        vm.getAccumulatedTimes(context: context)
        
        //Then
        XCTAssertGreaterThan(vm.accumulatedTimes.count, 0)
        XCTAssertEqual(answer[study], vm.accumulatedTimes[study])
        XCTAssertEqual(answer[game], vm.accumulatedTimes[game])
        
    }
    
    func test_StatViewModel_getAccumulatedTimes_shouldMakeOrderedDictionary() {
        //Given
        guard let vm = viewModel, let _ = preview, let context = context else {
            XCTFail()
            return
        }
        
        var answer: [KindEntity : [Int]] = [:]
        
        let study = KindEntity(context: context)
        study.id = UUID().uuidString
        study.name = "study"
        study.colorKindID = ColorKind.blue.rawValue
        
        let game = KindEntity(context: context)
        game.id = UUID().uuidString
        game.name = "game"
        game.colorKindID = ColorKind.red.rawValue
        
        for _ in 1..<10 {
            let returnedValue = makeTimetable(context: context, kinds: [study, game])
            if let kind = returnedValue.0 {
                answer[kind, default: []].append(returnedValue.1)
            }
        }
        
        //When
        vm.getAccumulatedTimes(context: context)
        
        //Then
        XCTAssertEqual(vm.accumulatedTimes[study], answer[game])
        XCTAssertEqual(vm.circleChartData[study], 0)
    }
}

extension StatViewModel_Tests {
    func makeTimetable(context: NSManagedObjectContext, kinds: [KindEntity]) -> (KindEntity?, Int) {
        let newTimetable = TimetableEntity(context: context)
        newTimetable.kindEntity = kinds.randomElement()
        newTimetable.id = UUID().uuidString
        newTimetable.date = Date().toDay.prevDay()
        newTimetable.duration = Int16(Int.random(in: 10..<500))
        newTimetable.hour = Int16(Int.random(in: 0..<24))
        newTimetable.minute = Int16(Int.random(in: 0..<6))
        
        do {
            try context.save()
        } catch {
            XCTFail()
        }
        
        return (newTimetable.kindEntity, Int(newTimetable.duration))
    }
}

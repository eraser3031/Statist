//
//  StatViewModel_Tests.swift
//  Statist_Tests
//
//  Created by Kimyaehoon on 11/12/2021.
//

import XCTest
@testable import Statist

class StatViewModel_Tests: XCTestCase {
    
    var viewModel: StatViewModel?
    var preview: CoreDataManager?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = StatViewModel()
        preview = CoreDataManager(inMemory: true)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        preview = nil
    }

    func test_StatViewModel_getDelayedTodoes_shouldGetItem(){
        //Given
        guard let vm = viewModel, let preview = preview else {
            XCTFail()
            return
        }
        XCTAssertNotEqual(vm.period.start, vm.period.end)
        let context = preview.container.newBackgroundContext()
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
        guard let vm = viewModel, let preview = preview else {
            XCTFail()
            return
        }

        let context = preview.container.newBackgroundContext()
        
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
        guard let vm = viewModel, let preview = preview else {
            XCTFail()
            return
        }
        let context = preview.container.newBackgroundContext()
        
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
        vm.inverseIsDoneOfTodo(context: context, todo: delayedTodoItem)
        
        // Then
        XCTAssertEqual(vm.delayedTodoes.count, 0)
    }
}

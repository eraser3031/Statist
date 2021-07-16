//
//  AlterFSCalendarView.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import SwiftUI
import FSCalendar
import Combine

struct CalendarView: UIViewRepresentable {
    
    @ObservedObject var environment: StatistViewModel
    @ObservedObject var vm: PlannerViewModel
    @Binding var rect: CGRect
    
    func makeUIView(context: UIViewRepresentableContext<CalendarView>) -> UIView {
        let view = UIView(frame: .zero)
        let calendar = FSCalendar()
        
        func setCalendar(calendar: FSCalendar) {
            calendar.delegate = context.coordinator
            calendar.dataSource = context.coordinator
            calendar.appearance.eventDefaultColor = .black
            calendar.appearance.borderRadius = 0.4
            calendar.appearance.headerMinimumDissolvedAlpha = 0
            calendar.appearance.eventSelectionColor = .black
            calendar.appearance.selectionColor = .black
            calendar.appearance.titleTodayColor = .black
            calendar.appearance.weekdayTextColor = .black
            calendar.appearance.todayColor = .systemGray5
            calendar.headerHeight = 0
            calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
            calendar.appearance.weekdayFont = UIFont(name: "Gilroy-Light", size: 10)
            calendar.appearance.titleFont = UIFont(name: "Gilroy-ExtraBold", size: 12)
            calendar.scope = vm.calendarScope ? .month : .week
        }
        
        setCalendar(calendar: calendar)
        
        view.addSubview(calendar)
        
        let newRect = CGRect(x: 0, y: 0, width: rect.width, height: 300)
        calendar.frame = newRect
        
        func addSubscriber() {
            vm.$calendarScope
                .sink { isOpen in
                    for subview in view.subviews {
                        if let calendar = subview as? FSCalendar {
                            calendar.setScope(isOpen ? .month : .week, animated: true)
                            print(isOpen ? "true" : "false")
                        }
                    }
                    
                }
                .store(in: &vm.cancellables)
            
            environment.$date
                .sink { date in
                    for subview in view.subviews {
                        if let calendar = subview as? FSCalendar {
                            calendar.select(date)
                        }
                    }
                }
                .store(in: &vm.cancellables)
            
        }
        
        addSubscriber()
        
        return view
    }
    
    func updateUIView(_ view: UIView, context: UIViewRepresentableContext<CalendarView>) {
        for calendar in view.subviews {
            if rect.width != calendar.frame.width {
                calendar.removeFromSuperview()
                let newRect = CGRect(x: 0, y: 0, width: rect.width, height: 300)
                let calendar = FSCalendar(frame: newRect)
                
                func setCalendar(calendar: FSCalendar) {
                    calendar.delegate = context.coordinator
                    calendar.dataSource = context.coordinator
                    calendar.appearance.eventDefaultColor = .black
                    calendar.appearance.borderRadius = 0.4
                    calendar.appearance.headerMinimumDissolvedAlpha = 0
                    calendar.appearance.eventSelectionColor = .black
                    calendar.appearance.selectionColor = .black
                    calendar.appearance.titleTodayColor = .black
                    calendar.appearance.weekdayTextColor = .black
                    calendar.appearance.todayColor = .systemGray5
                    calendar.headerHeight = 0
                    calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
                    calendar.appearance.weekdayFont = UIFont(name: "Gilroy-Light", size: 10)
                    calendar.appearance.titleFont = UIFont(name: "Gilroy-ExtraBold", size: 12)
                    calendar.scope = vm.calendarScope ? .month : .week
                }
                
                setCalendar(calendar: calendar)
                
                view.addSubview(calendar)
                
                print(rect)
            }
        }
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        
        @ObservedObject var environment: StatistViewModel
        @ObservedObject var vm: PlannerViewModel
        
        init(environment: StatistViewModel, model: PlannerViewModel) {
            self.environment = environment
            self.vm = model
        }
        
        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendar.frame = bounds
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            environment.date = date
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(environment: environment, model: vm)
    }
}


//
//  AlterFSCalendarView.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import SwiftUI
import FSCalendar
import Combine

struct NewCalendarView: UIViewRepresentable {

    @ObservedObject var vm: CalendarViewModel
    var geo: GeometryProxy
    var colorScheme: ColorScheme
    
    func setCalendar(_ calendar: FSCalendar, context: UIViewRepresentableContext<NewCalendarView>) {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.appearance.eventDefaultColor = colorScheme == .dark ? .white : .black
        calendar.appearance.borderRadius = 2
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.eventSelectionColor = colorScheme == .dark ? .white : .black
        calendar.appearance.selectionColor = colorScheme == .dark ? .white : .black
        calendar.appearance.titleTodayColor = colorScheme == .dark ? .white : .black
        calendar.appearance.weekdayTextColor = colorScheme == .dark ? .white : .black
        calendar.appearance.todayColor = .systemGray5
        calendar.headerHeight = 0
        calendar.appearance.titleSelectionColor = colorScheme == .dark ? .black : .white
        calendar.appearance.titleDefaultColor = colorScheme == .dark ? .white : .black
        calendar.appearance.subtitleDefaultColor = colorScheme == .dark ? .white : .black
        calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        calendar.appearance.weekdayFont = UIFont(name: "Gilroy-ExtraBold", size: 10)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        calendar.scope = vm.scope ? .month : .week
    }
    
    func makeUIView(context: UIViewRepresentableContext<NewCalendarView>) -> UIView {
        let view = UIView(frame: .zero)
        let calendar = FSCalendar()
        
        setCalendar(calendar, context: context)
        
        view.addSubview(calendar)
        
        let newRect = CGRect(x: 0, y: 0, width: geo.size.width, height: 300)
        calendar.frame = newRect
        
        func addSubscriber() {
            vm.$scope
                .sink { isOpen in
                    for subview in view.subviews {
                        if let calendar = subview as? FSCalendar {
                            calendar.setScope(isOpen ? .month : .week, animated: true)
                            print(isOpen ? "true" : "false")
                        }
                    }
                    
                }
                .store(in: &vm.cancellables)
            
            vm.$date
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
    
    func updateUIView(_ view: UIView, context: UIViewRepresentableContext<NewCalendarView>) {
        for calendar in view.subviews {
            if (geo.size.width) != calendar.frame.width {
                calendar.removeFromSuperview()
                let newRect = CGRect(x: 0, y: 0, width: geo.size.width, height: 300)
                let calendar = FSCalendar(frame: newRect)
                
                setCalendar(calendar, context: context)
                
                view.addSubview(calendar)
                
//                print(rect)
            }
        }
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        
        @ObservedObject var vm: CalendarViewModel
        
        init(vm: CalendarViewModel) {
            self.vm = vm
        }
        
        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendar.frame = bounds
        }
        
//        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//            print("didSelect: \(date.description)")
//            environment.date = date
//            print("didSelect/environment: \(environment.date.description)")
//            return true
//        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            vm.date = date
        }
    }
    
    func makeCoordinator() -> NewCalendarView.Coordinator {
        return Coordinator(vm: vm)
    }
}


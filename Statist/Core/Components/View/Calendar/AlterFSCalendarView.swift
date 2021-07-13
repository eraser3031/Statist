//
//  AlterFSCalendarView.swift
//  Statist
//
//  Created by Kimyaehoon on 13/07/2021.
//

import SwiftUI
import FSCalendar
import Combine

struct AlterFSCalendarView: UIViewRepresentable {
    
    @ObservedObject var vm: PlannerViewModel
    @Binding var rect: CGRect
    
    func makeUIView(context: UIViewRepresentableContext<AlterFSCalendarView>) -> UIView {
        let view = UIView(frame: .zero)
        let calendar = FSCalendar()
        calendar.scope = vm.calendarScope ? .month : .week
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.headerHeight = 0
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
        }
        
        addSubscriber()
        
        return view
    }
    
    func updateUIView(_ view: UIView, context: UIViewRepresentableContext<AlterFSCalendarView>) {
        for calendar in view.subviews {
            if rect.width != calendar.frame.width {
                calendar.removeFromSuperview()
                let newRect = CGRect(x: 0, y: 0, width: rect.width, height: 300)
                let calendar = FSCalendar(frame: newRect)
                calendar.scope = vm.calendarScope ? .month : .week
                calendar.delegate = context.coordinator
                calendar.dataSource = context.coordinator
                calendar.headerHeight = 0
                
                
                view.addSubview(calendar)
                
                print(rect)
            }
        }
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendar.frame = bounds
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

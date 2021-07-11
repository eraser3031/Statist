//
//  FSCalendarView.swift
//  Statist
//
//  Created by Kimyaehoon on 05/07/2021.
//

import SwiftUI
import Combine
import FSCalendar

struct FSCalendarView: UIViewRepresentable {
    
    @ObservedObject var vm: CalendarViewModel
    
    init(model: CalendarViewModel) {
        self.vm = model
    }
    
//    typealias UIViewType = FSCalendar
    
    func makeUIView(context: UIViewRepresentableContext<FSCalendarView>) -> UIView {
        let view = UIView(frame: .zero)
//        view.backgroundColor = .green
//                view.backgroundColor = .backgroundTheme

        let height: CGFloat = 300.0
        let width = UIScreen.main.bounds.width - 40
        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        let calendar = FSCalendar(frame: frame)
//        let calendar = FSCalendar()
        
        func addSubscriber() {
            vm.$scope
                .sink { isOpen in
//                        calendar.scope = isOpen ? .month : .week
                    calendar.setScope(isOpen ? .month : .week, animated: true)
                }
                .store(in: &vm.cancellables)
            
            vm.$date
                .sink { date in
                    calendar.select(date)
                }
                .store(in: &vm.cancellables)
        }
        
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
        calendar.scope = .week
//        calendar.backgroundColor = .red
        addSubscriber()
        
        view.addSubview(calendar)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<FSCalendarView>) {
        
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        
        @ObservedObject var vm: CalendarViewModel
        
        init(model: CalendarViewModel) {
            self.vm = model
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            vm.date = date
        }
        
        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendar.frame = bounds
//            calendar.select(vm.date)
        }
        
//        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//            vm.date = calendar.currentPage
////            calendar.select(calendar.currentPage)
//        }
        
        

    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(model: vm)
    }

}

struct FSCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        FSCalendarView(model: CalendarViewModel())
            .frame(height: 280)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

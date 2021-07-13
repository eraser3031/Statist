////
////  FSCalendarView.swift
////  Statist
////
////  Created by Kimyaehoon on 05/07/2021.
////
//
//import SwiftUI
//import Combine
//import FSCalendar
//
//struct FSCalendarView: UIViewRepresentable {
//    
//    @ObservedObject var vm: PlannerViewModel
//    
//    var width: CGFloat
//    var height: CGFloat
//    
//    init(model: PlannerViewModel, width: CGFloat, height: CGFloat) {
//        self.vm = model
//        self.width = width
//        self.height = height
//    }
//    
//    func makeUIView(context: UIViewRepresentableContext<FSCalendarView>) -> UIView {
//        let view = UIView(frame: .zero)
//
//        let frame = CGRect(x: 0.0, y: 0.0, width: width - 36, height: height)
//        let calendar = FSCalendar(frame: frame)
//        
//        func setCalendar(calendar: FSCalendar) {
//            calendar.delegate = context.coordinator
//            calendar.dataSource = context.coordinator
//            calendar.appearance.eventDefaultColor = .black
//            calendar.appearance.borderRadius = 0.4
//            calendar.appearance.headerMinimumDissolvedAlpha = 0
//            calendar.appearance.eventSelectionColor = .black
//            calendar.appearance.selectionColor = .black
//            calendar.appearance.titleTodayColor = .black
//            calendar.appearance.weekdayTextColor = .black
//            calendar.appearance.todayColor = .systemGray5
//            calendar.headerHeight = 0
//            calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
//            calendar.appearance.weekdayFont = UIFont(name: "Gilroy-Light", size: 10)
//            calendar.appearance.titleFont = UIFont(name: "Gilroy-ExtraBold", size: 12)
//            calendar.scope = vm.calendarScope ? .month : .week
//        }
//        
//        func addSubscriber() {
//            vm.$calendarScope
//                .sink { isOpen in
//                    calendar.setScope(isOpen ? .month : .week, animated: true)
//                }
//                .store(in: &vm.cancellables)
//            
//            vm.$date
//                .sink { date in
//                    calendar.select(date)
//                    for calendar in view.subviews {
//                        calendar.removeFromSuperview()
//                    }
//                    let calendar = FSCalendar(frame: frame)
//                    setCalendar(calendar: calendar)
//                    view.addSubview(calendar)
//                    view.setNeedsDisplay()
//                    calendar.setNeedsDisplay()
//                }
//                .store(in: &vm.cancellables)
//        }
//        
//        setCalendar(calendar: calendar)
//        addSubscriber()
//        
//        view.addSubview(calendar)
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<FSCalendarView>) {
////        for view in uiView.subviews {
////            view.frame = CGRect(x: 0.0, y: 0.0, width: width - 36, height: height)
////        }
//    }
//    
//    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
//        
//        @ObservedObject var vm: PlannerViewModel
//        var width: CGFloat
//        var height: CGFloat
//        
//        init(model: PlannerViewModel, width: CGFloat, height: CGFloat) {
//            self.vm = model
//            self.width = width
//            self.height = height
//        }
//        
//        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//            vm.date = date
//        }
//        
//        func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
////            calendar.select(vm.date)
//        }
//
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(model: vm, width: width, height: height)
//    }
//
//}
////
////struct FSCalendarView_Previews: PreviewProvider {
////    static var previews: some View {
////        FSCalendarView(model: PlannerViewModel())
////            .frame(height: 280)
////            .padding()
////            .previewLayout(.sizeThatFits)
////    }
////}

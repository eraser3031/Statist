//
//  PlannerView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct PlannerView: View {
    @StateObject var vm = PlannerViewModel()
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        
        return VStack{
            
            CalendarUpper(model: vm)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            GeometryReader { geo in
                VStack(spacing: 0) {
                    
                    FSCalendarView(model: vm, width: geo.size.width, height: 300).padding(.horizontal, 18)
                    
                    mainView(geo: geo)
                        .frame(height: vm.calendarScope ? geo.size.height - 300: geo.size.height - 80)
                        .animation(.spring(), value: vm.calendarScope)
                }
            }
        }
    }
}

extension PlannerView {
    private func mainView(geo: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color(.systemBackground))
            .overlay(
                VStack(alignment: .leading, spacing: 20) {
                    CustomPicker($vm.pickedItem, items: [.TodoList, .TimeTable, .Progress])
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    if vm.pickedItem == .TodoList {
                        TodoListView(date: vm.date)
                    } else if vm.pickedItem == .TimeTable {
                        TimetableView(date: vm.date)
                    } else {
                        ProgressView(date: vm.date)
                    }
                }
            )
    }
    
    private func calendarView(geo: GeometryProxy) -> some View {
        
        let ratio = geo.size.height / geo.size.width
        
        switch ratio {
        case 0.0..<0.2:
            return FSCalendarView(model: vm, width: geo.size.width, height: 300).padding(.horizontal, 18)
        case 0.2..<0.4:
            return FSCalendarView(model: vm, width: geo.size.width, height: 299).padding(.horizontal, 18)
        case 0.4..<0.6:
            return FSCalendarView(model: vm, width: geo.size.width, height: 301).padding(.horizontal, 18)
        case 0.6..<0.8:
            return FSCalendarView(model: vm, width: geo.size.width, height: 302).padding(.horizontal, 18)
        case 0.8..<1.0:
            return FSCalendarView(model: vm, width: geo.size.width, height: 298).padding(.horizontal, 18)
        case 1.0..<1.2:
            return FSCalendarView(model: vm, width: geo.size.width, height: 300.5).padding(.horizontal, 18)
        case 1.2..<1.4:
            return FSCalendarView(model: vm, width: geo.size.width, height: 299.5).padding(.horizontal, 18)
        case 1.4..<1.6:
            return FSCalendarView(model: vm, width: geo.size.width, height: 399.8).padding(.horizontal, 18)
        case 1.6..<1.8:
            return FSCalendarView(model: vm, width: geo.size.width, height: 300.8).padding(.horizontal, 18)
        case 1.8..<2.0:
            return FSCalendarView(model: vm, width: geo.size.width, height: 300.2).padding(.horizontal, 18)
        default:
            return FSCalendarView(model: vm, width: geo.size.width, height: 299.8).padding(.horizontal, 18)
        }
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}

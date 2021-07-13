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
    @State private var rect: CGRect = CGRect()
    
    var body: some View {
        
        return VStack{
            
            CalendarUpper(model: vm)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            GeometryReader { geo in
                VStack(spacing: 0) {
                    
//                    FSCalendarView(model: vm, width: geo.size.width, height: 300).padding(.horizontal, 18)
//                    Rectangle()
//                        .fill(Color(.systemBackground))
//                        .overlay(
//
//                        )
                    AlterFSCalendarView(vm: vm, rect: $rect)
                    
                    mainView(geo: geo)
                        .frame(height: vm.calendarScope ? geo.size.height - 320: geo.size.height - 100)
                        .animation(.spring(), value: vm.calendarScope)
                }
            }
            .background(GeometryGetter(rect: $rect))
        }
    }
}

extension PlannerView {
    private func mainView(geo: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color.blue)
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
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = geometry.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}

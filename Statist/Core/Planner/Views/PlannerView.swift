//
//  PlannerView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct PlannerView: View {
    
    @StateObject var environment = StatistViewModel()
    @StateObject var vm = PlannerViewModel()
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State private var rect: CGRect = CGRect()
    
    var body: some View {
        
        VStack(spacing: 12){
            HeaderView(environment: environment, model: vm)
                .padding(.horizontal, 20)
                .padding(.top, 12)
            
            GeometryReader { geo in
                VStack(spacing: 0) {
                    
                    if vm.pickedItem != .Progress {
                        CalendarView(environment: environment, vm: vm, rect: $rect)
                            .padding(.horizontal, 16)
                            .transition(.move(edge: .bottom))
                    }

                    mainView(geo: geo)
                        .frame(height: calMainViewHeight(geo))
                        .overlay(
                            Divider()
                                .foregroundColor(.theme.dividerColor)
                            ,alignment: .top
                        )
                        .animation(.spring(), value: vm.calendarScope)
                }
            }
            .background(GeometryGetter(rect: $rect))
        }
        .onReceive(vm.$pickedItem) { pickedItem in
            if pickedItem == .Progress {
                vm.calendarScope = false
                environment.date = Date().toDay
            }
        }

    }
    
    private func calMainViewHeight(_ geo: GeometryProxy) -> CGFloat {
        let minus: CGFloat = vm.pickedItem == .Progress ? 0 : vm.calendarScope ? 300 : 80
        return geo.size.height - minus
    }
}
 
extension PlannerView {
    private func mainView(geo: GeometryProxy) -> some View {
        Rectangle()
            .fill(Color(.systemBackground))
            .overlay(
                VStack(spacing: 20) {
                
                    CustomPicker($vm.pickedItem, items: [.TodoList, .TimeTable, .Progress])
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    if vm.pickedItem == .TodoList {
                        
                        TodoListView(date: environment.date)
                            .environmentObject(environment)
                        
                    } else if vm.pickedItem == .TimeTable {
                        
                        TimetableView(date: environment.date)
                            .environmentObject(environment)
                        
                    } else if vm.pickedItem == .Progress {
                        ProgressView()
                            .environmentObject(environment)
                        
                    } else {
                        EmptyView()
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

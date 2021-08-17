//
//  TimetableView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct TimetableView: View {
    @StateObject var vm = NewTimetableViewModel()
    let show: () -> Void
    
    let defaultAnimation = Animation.closeCard
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.vertical, 20)
            
            GroupedCalendarView(info: $vm.calendarInfo, dates: vm.events?.dates ?? [])
                .shadow(color: Color.theme.shadowColor.opacity(0.1), radius: 12, x: 0.0, y: 5)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            
            KindPicker($vm.selectedKind, showKindView: $vm.showKindView, kinds: vm.kinds)
                .shadow(color: Color.theme.shadowColor.opacity(0.1), radius: 12, x: 0, y: 5)
                .padding(.bottom, 16)
            
            timetable
                .shadow(color: Color.theme.shadowColor.opacity(0.1), radius: 12, x: 0, y: 5)
        }
        .onChange(of: vm.calendarInfo.date) { _ in
            withAnimation(defaultAnimation){
                vm.entitys()
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 0){
            Label("Timetable", systemImage: "line.3.horizontal.circle.fill")
                .scaledFont(name: CustomFont.Gilroy_ExtraBold, size: 22)
                .padding(.vertical, 2)
                .contentShape(Rectangle())
                .onTapGesture{
                    show()
                }
            
            Spacer()
            
            Circle()
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal, 20)
    }
    
    private var timetable: some View {
        GeometryReader { geo in
            TimeTable(models: vm.items, tapColumn: vm.changeItemsByHour) { item, outIndex, inIndex in
                Rectangle()
                    .fill(item?.color.toPrimary() ?? Color.clear)
                    .background(Divider(), alignment: .trailing)
                    .background(
                        VStack{
                            Spacer()
                            Divider()
                        }, alignment: .bottom)
                    .frame(minHeight: 48)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if item == nil {
                            withAnimation(defaultAnimation){
                                vm.items[outIndex][inIndex] = vm.selectedKind
                            }
                        } else {
                            withAnimation(defaultAnimation){
                                vm.items[outIndex][inIndex] = nil
                            }
                        }
                    }
                    .transition(.scale)
            }
            .frame(width: geo.size.width)
        }
    }
}
//
//struct TimetableView: View {
//    
//    @EnvironmentObject var environment: StatistViewModel
//    @StateObject var vm: TimeTableViewModel
//    
//    init(date: Date){
//        self._vm = StateObject(wrappedValue: TimeTableViewModel(date: date))
//    }
//    
//    var body: some View {
//        GeometryReader { geo in
//            VStack(spacing: 10){
//            
////                KindPicker($vm.selectedKind, showAddKindView: $vm.showAddKindView, kinds: vm.kinds)
////                    .sheet(isPresented: $vm.showAddKindView,
////                           onDismiss: {
////                            withAnimation(.spring()){
////                                vm.getKindEntitys()
////                            }
////                        }) {
////                            AddKindView()
////                    }
////            
//            
//                TimeTable(models: vm.items, tapColumn: vm.tapColumn) { item, outIndex, inIndex in
//                    Rectangle()
//                        .fill(item?.color.toPrimary() ?? Color.clear)
//                        .background(Divider(), alignment: .trailing)
//                        .background(
//                            VStack{
//                                Spacer()
//                                Divider()
//                            }, alignment: .bottom)
//                        .frame(minHeight: 48)
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            if item == nil {
//                                withAnimation(.easeOutExpo){
//                                    vm.items[outIndex][inIndex] = vm.selectedKind
//                                }
//                            } else {
//                                withAnimation(.easeOutExpo){
//                                    vm.items[outIndex][inIndex] = nil
//                                }
//                            }
//                        }
//                        .transition(.scale)
//                }
//                .frame(width: geo.size.width)
//                
//                LineChart(datas: [vm.timeTableEntitys])
//            }
//        }
//        .onReceive(environment.$date) { date in
//            withAnimation(.spring()) {
//                vm.getTimeTableEntitys(date: date)
//            }
//        }
//    }
//}
//
//struct TimetableView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimetableView(date: Date())
//    }
//}

//struct TimetableView: View {
//
//    @StateObject vm = TimeTableViewModel()
//
//    var body: some View {
//
//    }
//}

//
//  TimetableView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct TimetableView: View {
    
    @EnvironmentObject var environment: StatistViewModel
    @StateObject var vm: TimeTableViewModel
    
    init(date: Date){
        self._vm = StateObject(wrappedValue: TimeTableViewModel(date: date))
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10){
            
                KindPicker($vm.selectedKind, showAddKindView: $vm.showAddKindView, kinds: vm.kinds)
                    .sheet(isPresented: $vm.showAddKindView,
                           onDismiss: {
                            withAnimation(.spring()){
                                vm.getKindEntitys()
                            }
                        }) {
                            AddKindView()
                    }
            
            
                TimeTable(models: vm.items, tapColumn: vm.tapColumn) { item, outIndex, inIndex in
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
                                withAnimation(.easeOutExpo){
                                    vm.items[outIndex][inIndex] = vm.selectedKind
                                }
                            } else {
                                withAnimation(.easeOutExpo){
                                    vm.items[outIndex][inIndex] = nil
                                }
                            }
                        }
                        .transition(.scale)
                }
                .frame(width: geo.size.width)
            }
        }
        .onReceive(environment.$date) { date in
            withAnimation(.spring()) {
                vm.getTimeTableEntitys(date: date)
            }
        }
    }
}

struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView(date: Date())
    }
}

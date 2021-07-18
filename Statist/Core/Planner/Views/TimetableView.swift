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
        VStack{
            
            KindPicker($vm.selectedKind, showAddKindView: $vm.showAddKindView, kinds: vm.kinds)
            
            AlterTimeTable(items: vm.items, tapColumn: vm.tapColumn) { i in
                Rectangle()
                    .fill(vm.items[i.out][i.in]?.color.toPrimary() ?? Color.clear)
                    .background(Divider(), alignment: .trailing)
                    .background(
                        VStack{
                            Spacer()
                            Divider()
                        }, alignment: .bottom)
                    .frame(minHeight: 48)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if vm.items[i.out][i.in] == nil {
                            withAnimation(.easeOutExpo){
                                vm.items[i.out][i.in] = vm.decodeToKind()
                            }
                        } else {
                            withAnimation(.easeOutExpo){
                                vm.items[i.out][i.in] = nil
                            }
                        }
                    }
                    .transition(.scale)
            }
        }
    }
}

struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView(date: Date())
    }
}

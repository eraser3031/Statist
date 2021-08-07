//
//  GroupedCalendarView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/08/2021.
//

import SwiftUI

struct GroupedCalendarView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            NewHeaderView(vm: vm)
            
            Divider()
            
            GeometryReader { geo in
                NewCalendarView(vm: vm, geo: geo, colorScheme: colorScheme)
                    .id(self.colorScheme)
            }.frame(height: vm.scope ? 300 : 80)
        }
        .padding(14)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.theme.dividerColor)
                .padding(0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

//struct GroupedCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupedCalendarView()
//    }
//}

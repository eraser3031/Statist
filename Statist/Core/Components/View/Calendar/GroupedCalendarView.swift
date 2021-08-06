//
//  GroupedCalendarView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/08/2021.
//

import SwiftUI

struct GroupedCalendarView: View {
    
    @ObservedObject var vm: CalendarViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            NewHeaderView(vm: vm)
            
            Divider()
            
            NewCalendarView(vm: vm)
                .frame(height: vm.scope ? 300 : 80)
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color(#colorLiteral(red: 0.1333333, green: 0.3098039, blue: 0.662745, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
    }
}

//struct GroupedCalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupedCalendarView()
//    }
//}

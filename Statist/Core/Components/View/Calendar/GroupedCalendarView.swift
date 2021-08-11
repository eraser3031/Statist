//
//  GroupedCalendarView.swift
//  Statist
//
//  Created by Kimyaehoon on 06/08/2021.
//

import SwiftUI

struct GroupedCalendarView: View {
    
    @Binding var info: CalendarInfo
    let dates: [Date]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 10) {
            NewHeaderView(info: $info)
            
            Divider()
            
            GeometryReader { geo in
                NewCalendarView(info: $info, geo: geo, dates: dates, colorScheme: colorScheme)
                    .id(self.colorScheme)
                    .id(dates)
            }.frame(height: info.scope ? 300 : 80)
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

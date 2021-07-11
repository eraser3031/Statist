//
//  CustomCalendar.swift
//  Statist
//
//  Created by Kimyaehoon on 04/07/2021.
//

import SwiftUI

struct CustomCalendar: View {
    
    @ObservedObject var vm: CalendarViewModel
    
    init(model: CalendarViewModel){
        self.vm = model
    }
    
    var body: some View {
        VStack(spacing: 10){
            
            CalendarUpper(model: vm)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            FSCalendarView(model: vm)
                .padding(.horizontal, 20)
                
        }
    }
}

//struct CustomCalendar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomCalendar()
//            .previewLayout(.sizeThatFits)
//    }
//}

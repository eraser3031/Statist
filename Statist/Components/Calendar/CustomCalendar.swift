//
//  CustomCalendar.swift
//  Statist
//
//  Created by Kimyaehoon on 04/07/2021.
//

import SwiftUI

struct CustomCalendar: View {
    
    @ObservedObject var vm: PlannerViewModel
    var width: CGFloat
    var height: CGFloat
    
    init(model: PlannerViewModel, width: CGFloat, height: CGFloat){
        self.vm = model
        self.width = width
        self.height = height
    }
    
    var body: some View {
        VStack(spacing: 10){
            
            CalendarUpper(model: vm)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
//            FSCalendarView(model: vm, width: width,  height: height)
//                .padding(.horizontal, 18)
                
        }
    }
}

//struct CustomCalendar_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomCalendar()
//            .previewLayout(.sizeThatFits)
//    }
//}

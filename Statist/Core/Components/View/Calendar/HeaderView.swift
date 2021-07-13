//
//  CalendarUpper.swift
//  Statist
//
//  Created by Kimyaehoon on 04/07/2021.
//

import SwiftUI

struct HeaderView: View {
    
    @ObservedObject var vm: PlannerViewModel
    
    init(model: PlannerViewModel) {
        self.vm = model
    }
    
    var body: some View {
        HStack {
            Text(vm.date.titleString())
                .font(.title)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    vm.date = Date()
                }
            
            Image(systemName: "calendar")
                .font(.title2)
                .onTapGesture {
                    vm.calendarScope.toggle()
                }
        }
        .padding(.horizontal, 8)
    }
}

struct CalendarUpper_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(model: PlannerViewModel())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

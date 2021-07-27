//
//  CalendarUpper.swift
//  Statist
//
//  Created by Kimyaehoon on 04/07/2021.
//

import SwiftUI

struct HeaderView: View {
    
    @ObservedObject var environment: StatistViewModel
    @ObservedObject var vm: PlannerViewModel
    @State var alterDate: Date = Date().toDay
    
    init(environment: StatistViewModel, model: PlannerViewModel) {
        self.environment = environment
        self.vm = model
    }
     
    var body: some View {
        HStack {
            Text(alterDate.titleString())
                .font(.title2)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    environment.date = Date().toDay
                }
            
            Image(systemName: "calendar")
                .font(.title2)
                .onTapGesture {
                    vm.calendarScope.toggle()
                }
        }
        .padding(.horizontal, 8)
        .onReceive(environment.$date) { date in
            alterDate = date
        }
    }
}

struct CalendarUpper_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(environment: StatistViewModel(), model: PlannerViewModel())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

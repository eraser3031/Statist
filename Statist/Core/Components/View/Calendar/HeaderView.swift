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

struct NewHeaderView: View {
    
    @ObservedObject var vm: CalendarViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(Font.system(.subheadline, design: .default).weight(.medium))
                Text(vm.date.titleString())
                    .font(Font.system(.subheadline, design: .default).weight(.heavy))
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    vm.scope.toggle()
                }
            }) {
                Label("Open", systemImage: "scroll")
                    .font(.caption2)
                    .foregroundColor(Color(.systemGray))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color(.quaternaryLabel))
                    )
            }
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

/*
 로비뷰 - 플래너뷰모델 ( 선택된 아이템 )
 
 투두뷰 타임테이블뷰 골뷰
 */

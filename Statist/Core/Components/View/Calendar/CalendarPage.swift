//
//  CalendarPage.swift
//  Statist
//
//  Created by Kimyaehoon on 04/07/2021.
//

import SwiftUI

struct CalendarPage: View {
    
    @ObservedObject var vm: CalendarViewModel
    
    var body: some View {
        TabView(selection: $vm.tabID) {
            ForEach(vm.tabs){ date in
                Rectangle()
                    .stroke(Color.blue)
                    .tag(date)
                    .id(date)
                    .overlay(
                        Text("\(date)")
                    )
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

struct CalendarPage_Previews: PreviewProvider {
    static var previews: some View {
        CalendarPage(vm: CalendarViewModel())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

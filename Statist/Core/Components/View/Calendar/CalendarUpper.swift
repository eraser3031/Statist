//
//  CalendarUpper.swift
//  Statist
//
//  Created by Kimyaehoon on 04/07/2021.
//

import SwiftUI

struct CalendarUpper: View {
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @ObservedObject var vm: CalendarViewModel
    
    init(model: CalendarViewModel) {
        self.vm = model
    }
    
    var body: some View {
        HStack {
            Text(vm.date.titleString())
                .font(.largeTitle)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onTapGesture {
                    vm.date = Date()
                    vm.scope = false
                }
            
            Image(systemName: "calendar")
                .font(.title)
                .onTapGesture {
                    vm.scope.toggle()
                }
        }
        .padding(.horizontal, 8)
    }
}

struct CalendarUpper_Previews: PreviewProvider {
    static var previews: some View {
        CalendarUpper(model: CalendarViewModel())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

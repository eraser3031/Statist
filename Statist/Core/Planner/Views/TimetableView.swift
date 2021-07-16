//
//  TimetableView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct TimetableView: View {
    
    @EnvironmentObject var environment: StatistViewModel
    @StateObject var vm: TimeTableViewModel
    
    init(date: Date){
        self._vm = StateObject(wrappedValue: TimeTableViewModel(date: date))
    }
    
    var body: some View {
        ZStack{
            TimeTable()
        }
    }
}

struct TimetableView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView(date: Date())
    }
}

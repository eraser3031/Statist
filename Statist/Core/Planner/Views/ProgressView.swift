//
//  ProgressView.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct ProgressView: View {
    
    @EnvironmentObject var environment: StatistViewModel
    @StateObject var vm: ProgressViewModel
    
    init(date: Date){
        self._vm = StateObject(wrappedValue: ProgressViewModel(date: date))
    }
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(date: Date())
    }
}

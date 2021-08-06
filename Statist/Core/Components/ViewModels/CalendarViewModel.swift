//
//  CalendarViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 05/07/2021.
//

import SwiftUI
import Combine

class CalendarViewModel: ObservableObject {
    
    @Published var date: Date = Date().toDay
    @Published var scope: Bool = false
    @Published var rect: CGRect = CGRect()
    
    var cancellables = Set<AnyCancellable>()
}

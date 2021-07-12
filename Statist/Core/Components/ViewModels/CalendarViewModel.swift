//
//  CalendarViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 05/07/2021.
//

import SwiftUI
import Combine

class CalendarViewModel: ObservableObject {
    @Published var date = Date()
    @Published var scope: Bool = false
}

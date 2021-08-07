//
//  CalendarViewModel.swift
//  Statist
//
//  Created by Kimyaehoon on 05/07/2021.
//

import SwiftUI
import Combine

struct CalendarInfo {
    var date: Date = Date().toDay.prevWeek().prevWeek().nextDay().nextDay().nextDay().nextDay().nextDay()
    var scope: Bool = false
}

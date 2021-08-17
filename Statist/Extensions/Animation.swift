//
//  Animation.swift
//  Statist
//
//  Created by Kimyaehoon on 18/07/2021.
//

import Foundation
import SwiftUI

extension Animation {
    static let easeOutExpo = Animation.timingCurve(0.87, 0, 0.13, 1, duration: 0.5)
    static let openCard = Animation.spring(response: 0.45, dampingFraction: 1)
    static let closeCard = Animation.spring(response: 0.35, dampingFraction: 1)
    static let flipCard = Animation.spring(response: 0.35, dampingFraction: 0.7)
}

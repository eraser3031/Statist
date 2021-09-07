//
//  Color.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
//    let accent = Color("AccentColor")
//    let background = Color("BackgroundColor")
//    let green = Color("GreenColor")
//    let red = Color("RedColor")
//    let secondaryText = Color("SecondaryTextColor")
    let backgroundColor = Color("BackgroundColor")
    let dividerColor = Color("DividerColor")
    let itemBackgroundColor = Color("ItemBackgroundColor")
    let shadowColor = Color("ShadowColor")
    let groupBackgroundColor = Color("GroupBackgroundColor")
    let subBackgroundColor = Color("SubBackgroundColor")
    let groupItemBackgroundColor = Color("GroupItemBackgroundColor")
    let inverseBackgroundColor = Color("InverseBackgroundColor")
}

enum ColorKind: String, Identifiable, Codable, CaseIterable {
    
    var id: String {
        return self.rawValue
    }
    
    static func string(name: String) -> ColorKind? {
        return self.allCases.filter{$0.rawValue == name}.first ?? nil
    }
    
    func primary() -> Color {
        switch self{
        case .hotpink:
            return Color(.systemPink)
        case .red:
            return Color(.systemRed)
        case .orange:
            return Color(.systemOrange)
        case .yellow:
            return Color(.systemYellow)
        case .green:
            return Color(.systemGreen)
        case .teal:
            return Color(.systemTeal)
        case .blue:
            return Color(.systemBlue)
        case .violet:
            return Color(.systemPurple)
        case .purple:
            return Color("Purple")
        case .pink:
            return Color("Pink")
        case .apricot:
            return Color("Apricot")
        case .leaf:
            return Color("Leaf")
        case .indigo:
            return Color(.systemIndigo)
        case .sky:
            return Color("Sky")
        case .brown:
            return Color("Brown")
        }
        
    }
    
    func secondary() -> Color {
        let opacity: Double = 0.1
        switch self{
        case .hotpink:
            return Color(.systemPink).opacity(opacity)
        case .red:
            return Color(.systemRed).opacity(opacity)
        case .orange:
            return Color(.systemOrange).opacity(opacity)
        case .yellow:
            return Color(.systemYellow).opacity(opacity)
        case .green:
            return Color(.systemGreen).opacity(opacity)
        case .teal:
            return Color(.systemTeal).opacity(opacity)
        case .blue:
            return Color(.systemBlue).opacity(opacity)
        case .violet:
            return Color(.systemPurple).opacity(opacity)
        case .purple:
            return Color("Purple").opacity(opacity)
        case .pink:
            return Color("Pink").opacity(opacity)
        case .apricot:
            return Color("Apricot").opacity(opacity)
        case .leaf:
            return Color("Leaf").opacity(opacity)
        case .indigo:
            return Color(.systemIndigo).opacity(opacity)
        case .sky:
            return Color("Sky").opacity(opacity)
        case .brown:
            return Color("Brown").opacity(opacity)
        }
    }
    
    case hotpink
    case red
    case apricot
    case orange
    case yellow
    case green
    case leaf
    case teal
    case sky
    case blue
    case indigo
    case violet
    case purple
    case pink
    case brown
}

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
    let dividerColor = Color("DividerColor")
    let itemBackgroundColor = Color("ItemBackgroundColor")
    let shadowColor = Color("ShadowColor")
}

enum ColorKind: String, Identifiable, Codable, CaseIterable {
    
    var id: String {
        return self.rawValue
    }
    
    static func string(name: String) -> ColorKind? {
        return self.allCases.filter{$0.rawValue == name}.first ?? nil
    }
    
    func toPrimary() -> Color {
        switch self{
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
        case .purple:
            return Color("Purple")
        case .pink:
            return Color("Pink")
        }
    }
    
    func toSecondary() -> Color {
        switch self{
        case .red:
            return Color("RedSecondary")
        case .orange:
            return Color("OrangeSecondary")
        case .yellow:
            return Color("YellowSecondary")
        case .green:
            return Color("GreenSecondary")
        case .teal:
            return Color("TealSecondary")
        case .blue:
            return Color("BlueSecondary")
        case .purple:
            return Color("PurpleSecondary")
        case .pink:
            return Color("PinkSecondary")
        }
    }
    
    case red
    case orange
    case yellow
    case green
    case teal
    case blue
    case purple
    case pink
}

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
    
    func secondary() -> Color {
        let opacity: CGFloat = 0.1
        switch self{
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
        case .purple:
            return Color("Purple").opacity(opacity)
        case .pink:
            return Color("Pink").opacity(opacity)
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

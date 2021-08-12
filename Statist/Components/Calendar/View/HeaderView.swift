//
//  CalendarUpper.swift
//  Statist
//
//  Created by Kimyaehoon on 04/07/2021.
//

import SwiftUI

struct HeaderView: View {
    
    @Binding var info: CalendarInfo
    @State var alterDate: Date = Date().toDay
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(Font.system(.subheadline, design: .default).weight(.medium))
                Text(info.date.titleString())
                    .font(Font.system(.subheadline, design: .default).weight(.heavy))
                    .onTapGesture {
                        info.date = Date().toDay
                    }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    info.scope.toggle()
                }
            }) {
                Label(info.scope ? "CLOSE" : "OPEN", systemImage: "scroll")
                    .font(.caption2)
                    .foregroundColor(Color(.systemGray))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.theme.itemBackgroundColor)
                    )
            }
        }
    }
}

/*
 로비뷰 - 플래너뷰모델 ( 선택된 아이템 )
 
 투두뷰 타임테이블뷰 골뷰
 */

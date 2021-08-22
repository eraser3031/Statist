//
//  TimeTableRow.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct TimeTableHeader: View {
    var body: some View {
        HStack(spacing: 0){
            Rectangle()
                .fill(Color.theme.backgroundColor)
                .frame(maxWidth: 48)
                .overlay(Divider(), alignment: .trailing)
            
            ForEach(1..<6) { i in
                GeometryReader { geo in
                    Rectangle()
                        .fill(Color.theme.backgroundColor)
                        .overlay(
                            Text("\(i*10)")
                                .font(.footnote)
                                .foregroundColor(Color(.darkGray))
                        )
                        .offset(x: geo.size.width/2)
                }
                .zIndex(1)
            }
            
            
            Rectangle()
                .fill(Color.theme.backgroundColor)
        }
        .frame(height: 24)
        .background(Color.theme.backgroundColor)
        .overlay(
            Rectangle()
                .stroke(Color.theme.dividerColor, lineWidth: 1)
        )
    }
}

struct TimeTableHeader_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableHeader()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

//
//  TimeTableRow.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct TimeTableRow: View {
    var body: some View {
        HStack(spacing: 0){
            Rectangle()
                .fill(Color(.systemBackground))
                .frame(maxWidth: 48)
                .overlay(
                    Divider()
                        .foregroundColor(.theme.dividerColor),
                    alignment: .trailing
                )
            
            ForEach(1..<6) { i in
                GeometryReader { geo in
                    Rectangle()
                        .fill(Color(.systemBackground))
                        .overlay(
                            Text("\(i*10)")
                                .font(.footnote)
                                .foregroundColor(Color(.tertiaryLabel))
                        )
                        .offset(x: geo.size.width/2)
                }
                .zIndex(1)
            }
            
            
            Rectangle()
                .fill(Color(.systemBackground))
        }
        .frame(height: 24)
        .background(Color(.systemBackground))
    }
}

struct TimeTableRow_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableRow()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

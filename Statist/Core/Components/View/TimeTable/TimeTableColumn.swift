//
//  TimeTableColumn.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct TimeTableColumn: View {
    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<25) { i in
                Rectangle()
                    .fill(Color(.systemBackground))
                    .frame(maxWidth: 48, minHeight: 48)
                    .overlay(
                        Text("\(i)")
                            .font(.footnote)
                            .foregroundColor(Color(.tertiaryLabel))
                    )
            }
        }
    }
}

struct TimeTableColumn_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableColumn()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

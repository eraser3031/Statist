//
//  TimeTableColumn.swift
//  Statist
//
//  Created by Kimyaehoon on 08/07/2021.
//

import SwiftUI

struct TimeTableColumn: View {
    
    let tapColumn: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<24) { i in
                Rectangle()
                    .fill(Color.theme.backgroundColor)
                    .frame(maxWidth: 48, minHeight: 48)
                    .overlay(
                        Text("\(i)")
                            .font(.subheadline)
                            .foregroundColor(Color(.darkGray))
                    )
                    .onTapGesture {
                        withAnimation(.easeOutExpo) {
                            tapColumn(i)
                        }
                    }
            }
        }
    }
}
//
//struct TimeTableColumn_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeTableColumn()
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}

//
//  TimeTableItem.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct TimeTableItem: View {
    
    var body: some View {
        
        HStack(spacing: 0){
            ForEach(0..<6){ i in
                Rectangle()
                    .fill(Color(.systemBackground))
                    .overlay(
                        Divider()
                            .foregroundColor(i == 5 ? .clear : .theme.dividerColor),
                        alignment: .trailing
                    )
                    .frame(minHeight: 48)
            }
        }
    }
}

struct TimeTableItem_Previews: PreviewProvider {
    static var previews: some View {
        TimeTableItem()
            .previewLayout(.fixed(width: 50, height: 45))
    }
}

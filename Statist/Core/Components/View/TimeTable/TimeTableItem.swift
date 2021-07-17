//
//  TimeTableItem.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct TimeTableItem: View {
    
    var body: some View {
        
        HStack(spacing: 1){
            ForEach(0..<6){ i in
                Rectangle()
                    .fill(Color(.systemBackground))
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

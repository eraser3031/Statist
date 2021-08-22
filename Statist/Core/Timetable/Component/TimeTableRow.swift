//
//  TimeTableItem.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct TimeTableRow<ItemView>: View where ItemView: View {
    
    let index: Int
    let items: [KindEntity?]
    let content: (KindEntity?, Int, Int) -> ItemView
    
    init(
        index: Int,
        models: [KindEntity?],
        @ViewBuilder content: @escaping (KindEntity?, Int, Int) -> ItemView
    ) {
        self.index = index
        self.items = models
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(0..<6){ i in
                self.content( items[i], index, i )
            }
        }.background(Color.theme.backgroundColor)
    }
}

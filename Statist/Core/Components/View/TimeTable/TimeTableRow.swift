//
//  TimeTableItem.swift
//  Statist
//
//  Created by Kimyaehoon on 06/07/2021.
//

import SwiftUI

struct TimeTableRow: View {
    
    let selectedKind: Kind?
    
    init(_ selectedKind: Kind?) {
        self.selectedKind = selectedKind
    }
    
    var body: some View {
        HStack(spacing: 1){
            ForEach(0..<6){ i in
                TimeTableItem(selectedKind)
            }
        }
    }
}

//struct TimeTableRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeTableRow()
//            .previewLayout(.fixed(width: 50, height: 45))
//    }
//}

struct AlterTimeTableRow<ItemView>: View where ItemView: View {
    
    typealias indexes = (out: Int, in: Int)
    let index: Int
    let items: [Kind?]
    let content: (indexes) -> ItemView
    
    init(
        index: Int,
        items: [Kind?],
        @ViewBuilder content: @escaping (indexes) -> ItemView
    ) {
        self.index = index
        self.items = items
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(0..<6){ i in
                self.content( (index, i) )
            }
        }
    }
}

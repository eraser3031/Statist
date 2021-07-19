//
//  TimeTableItem.swift
//  Statist
//
//  Created by Kimyaehoon on 17/07/2021.
//

import SwiftUI

struct TimeTableItem: View {
    
    let model: TTItemModel
    @State var kind: KindEntity?
    
    init(_ model: TTItemModel) {
        self.model = model
    }
    
    var body: some View {
        Rectangle()
            .fill(model.kindEntity?.color.toPrimary() ?? Color(.systemBackground))
            .frame(minHeight: 48)
            .onTapGesture {
                kind = model.kindEntity
            }
    }
}

//struct TimeTableItem_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeTableItem(.constant(Kind))
//    }
//}

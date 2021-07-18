//
//  TimeTableItem.swift
//  Statist
//
//  Created by Kimyaehoon on 17/07/2021.
//

import SwiftUI

struct TimeTableItem: View {
    
    let selectedKind: Kind?
    @State var kind: Kind?
    
    init(_ selectedKind: Kind?) {
        self.selectedKind = selectedKind
    }
    
    var body: some View {
        Rectangle()
            .fill(kind?.color.toPrimary() ?? Color(.systemBackground))
            .frame(minHeight: 48)
            .onTapGesture {
                kind = selectedKind
            }
    }
}

//struct TimeTableItem_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeTableItem(.constant(Kind))
//    }
//}
